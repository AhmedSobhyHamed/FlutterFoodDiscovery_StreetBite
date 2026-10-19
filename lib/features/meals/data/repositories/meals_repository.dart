import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/datasources/meals_local_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/datasources/meals_remote_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/models/category_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/models/meal_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/category_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/repositories/meals_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/l10n/meals_locale.dart';

class MealsRepository implements MealsRepositoryInterface {
  MealsRepository({required MealsLocalInterface local, required MealsRemoteInterface remote})
    : _local = local,
      _remote = remote;

  final MealsLocalInterface _local;
  final MealsRemoteInterface _remote;

  @override
  Future<Either<List<CategoryEntity>, String>> getCategories() async {
    final result = await _cacheFirst<List<CategoryModel>>(
      read: _local.getCategories,
      fetch: _remote.getCategories,
      save: _local.saveCategories,
      fallback: MealsLocale.categoriesFailed,
    );
    return result.fold(
      (categories) => Left(categories.cast<CategoryEntity>()),
      Right.new,
    );
  }

  @override
  Future<Either<List<MealEntity>, String>> getMealsByCategory(String category) async {
    final result = await _cacheFirst<List<MealModel>>(
      read: () => _local.getMealsByCategory(category),
      fetch: () => _remote.getMealsByCategory(category),
      save: (meals) => _local.saveMealsByCategory(category, meals),
      fallback: MealsLocale.mealsFailed,
    );
    return result.fold(
      (meals) => Left(meals.cast<MealEntity>()),
      Right.new,
    );
  }

  @override
  Future<Either<List<MealEntity>, String>> getHotOffers() async {
    final result = await _cacheFirst<List<MealModel>>(
      read: _local.getHotOffers,
      fetch: _remote.getHotOffers,
      save: _local.saveHotOffers,
      fallback: MealsLocale.offersFailed,
    );
    return result.fold(
      (offers) => Left(offers.cast<MealEntity>()),
      Right.new,
    );
  }

  @override
  Future<Either<MealEntity, String>> getMealDetails(String id) async {
    final result = await _cacheFirst<MealModel>(
      read: () => _local.getMealDetails(id),
      fetch: () => _remote.getMealDetails(id),
      save: _local.saveMealDetails,
      fallback: MealsLocale.detailsFailed,
    );
    return result.fold(Left.new, Right.new);
  }

  @override
  Future<String?> getSelectedCategory() async {
    try {
      return await _local.getSelectedCategory();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveSelectedCategory(String category) async {
    try {
      await _local.saveSelectedCategory(category);
    } catch (_) {}
  }

  @override
  Future<Either<bool, String>> clearHome() async {
    try {
      await _local.clearHome();
      return const Left(true);
    } on AppException catch (error) {
      return Right(error.message);
    } catch (_) {
      return const Right(MealsLocale.mealsFailed);
    }
  }

  // local storage first, then the remote api
  Future<Either<T, String>> _cacheFirst<T>({
    required Future<T> Function() read,
    required Future<T> Function() fetch,
    required Future<void> Function(T value) save,
    required String fallback,
  }) async {
    try {
      return Left(await read());
    } catch (_) {}

    try {
      final value = await fetch();
      try {
        await save(value);
      } catch (_) {}
      return Left(value);
    } on AppException catch (error) {
      return Right(error.message);
    } catch (_) {
      return Right(fallback);
    }
  }
}
