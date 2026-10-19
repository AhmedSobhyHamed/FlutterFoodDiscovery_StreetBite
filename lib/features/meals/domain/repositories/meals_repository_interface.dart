import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/category_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';

abstract interface class MealsRepositoryInterface {
  Future<Either<List<CategoryEntity>, String>> getCategories();

  Future<Either<List<MealEntity>, String>> getMealsByCategory(String category);

  Future<Either<List<MealEntity>, String>> getHotOffers();

  Future<Either<MealEntity, String>> getMealDetails(String id);

  Future<String?> getSelectedCategory();

  Future<void> saveSelectedCategory(String category);
}
