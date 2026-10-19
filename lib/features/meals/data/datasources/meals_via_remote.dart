import 'package:dio/dio.dart';
import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/remote_data_source.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/api/meals_api.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/datasources/meals_remote_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/models/category_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/models/meal_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/l10n/meals_locale.dart';

class MealsViaRemote extends RemoteDataSource implements MealsRemoteInterface {
  MealsViaRemote(Dio dio) : super(dio);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final data = await _get(MealsApi.categories);
    final categories = _readList(data, 'categories').map(CategoryModel.fromJson).toList();
    if (categories.isEmpty) {
      throw GeneralException(message: MealsLocale.notFound);
    }
    return categories;
  }

  @override
  Future<List<MealModel>> getMealsByCategory(String category) async {
    final data = await _get(MealsApi.filter, {'c': category});
    return _readList(data, 'meals').map(MealModel.fromJson).toList();
  }

  @override
  Future<List<MealModel>> getHotOffers() async {
    // random.php returns one meal, so call it five times
    final responses = await Future.wait(
      List.generate(5, (_) => _get(MealsApi.random)),
    );
    final offers = <MealModel>[];
    for (final data in responses) {
      final meals = _readList(data, 'meals');
      if (meals.isEmpty) continue;
      offers.add(MealModel.fromJson(meals.first));
    }
    if (offers.isEmpty) {
      throw GeneralException(message: MealsLocale.notFound);
    }
    return offers;
  }

  @override
  Future<MealModel> getMealDetails(String id) async {
    final data = await _get(MealsApi.lookup, {'i': id});
    final meals = _readList(data, 'meals');
    if (meals.isEmpty) {
      throw GeneralException(message: MealsLocale.notFound);
    }
    return MealModel.fromJson(meals.first);
  }

  Future<Map<String, dynamic>> _get(String path, [Map<String, dynamic>? query]) async {
    final result = await getMap(path, queryParams: query);
    return result.fold((data) => data, (error) {
      final offline = error.message == 'unknown error';
      throw GeneralException(
        message: offline ? MealsLocale.noConnection : MealsLocale.mealsFailed,
      );
    });
  }

  List<Map<String, dynamic>> _readList(Map<String, dynamic> data, String key) {
    if (data[key] is! List) return const [];
    return (data[key] as List)
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
