import 'package:flutterfooddiscovery_streetbite/features/meals/data/models/category_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/models/meal_model.dart';

abstract interface class MealsLocalInterface {
  Future<List<CategoryModel>> getCategories();

  Future<void> saveCategories(List<CategoryModel> categories);

  Future<List<MealModel>> getMealsByCategory(String category);

  Future<void> saveMealsByCategory(String category, List<MealModel> meals);

  Future<List<MealModel>> getHotOffers();

  Future<void> saveHotOffers(List<MealModel> meals);

  Future<MealModel> getMealDetails(String id);

  Future<void> saveMealDetails(MealModel meal);

  Future<String?> getSelectedCategory();

  Future<void> saveSelectedCategory(String category);

  Future<void> clearHome();
}
