import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/local_data_source.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/api/meals_api.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/datasources/meals_local_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/models/category_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/models/meal_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/l10n/meals_locale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealsViaLocal extends LocalDataSource implements MealsLocalInterface {
  MealsViaLocal(SharedPreferences preferences) : super(preferences);

  @override
  Future<List<CategoryModel>> getCategories() {
    return _readList(MealsApi.categoriesCache, CategoryModel.fromJson);
  }

  @override
  Future<void> saveCategories(List<CategoryModel> categories) {
    return _saveList(
      MealsApi.categoriesCache,
      categories.map((category) => category.toJson()).toList(),
    );
  }

  @override
  Future<List<MealModel>> getMealsByCategory(String category) {
    return _readList(MealsApi.mealsCache(category), MealModel.fromJson);
  }

  @override
  Future<void> saveMealsByCategory(String category, List<MealModel> meals) {
    return _saveList(
      MealsApi.mealsCache(category),
      meals.map((meal) => meal.toJson()).toList(),
    );
  }

  @override
  Future<List<MealModel>> getHotOffers() {
    return _readList(MealsApi.offersCache, MealModel.fromJson);
  }

  @override
  Future<void> saveHotOffers(List<MealModel> meals) {
    return _saveList(
      MealsApi.offersCache,
      meals.map((meal) => meal.toJson()).toList(),
    );
  }

  @override
  Future<MealModel> getMealDetails(String id) async {
    final stored = await getEntity(MealsApi.detailsCache, id);
    return stored.fold((meal) {
      return MealModel.fromJson(meal);
    }, (_) {
      throw GeneralException(message: MealsLocale.notFound);
    });
  }

  @override
  Future<String?> getSelectedCategory() async {
    final stored = await getEntity(
      MealsApi.selectedCategoryCache,
      MealsApi.selectedCategoryId,
    );
    return stored.fold(
      (data) => data['category']?.toString(),
      (_) => null,
    );
  }

  @override
  Future<void> saveSelectedCategory(String category) async {
    final payload = {
      'id': MealsApi.selectedCategoryId,
      'category': category,
    };
    final updated = await put(
      MealsApi.selectedCategoryCache,
      MealsApi.selectedCategoryId,
      payload,
    );
    if (updated.isLeft()) return;
    await post(MealsApi.selectedCategoryCache, payload);
  }

  @override
  Future<void> saveMealDetails(MealModel meal) async {
    final stored = await post(MealsApi.detailsCache, meal.toJson());
    stored.fold((_) {}, (_) {
      throw GeneralException(message: MealsLocale.detailsFailed);
    });
  }

  Future<List<T>> _readList<T>(
    String key,
    T Function(Map<String, dynamic> json) decode,
  ) async {
    final stored = await getList(key);
    return stored.fold((data) {
      if (data.isEmpty) {
        throw GeneralException(message: MealsLocale.notFound);
      }
      return data.map(decode).toList();
    }, (_) {
      throw GeneralException(message: MealsLocale.notFound);
    });
  }

  Future<void> _saveList(String key, List<Map<String, dynamic>> items) async {
    for (final item in items) {
      final stored = await post(key, item);
      final failed = stored.isRight();
      if (failed) {
        throw GeneralException(message: MealsLocale.mealsFailed);
      }
    }
  }
}
