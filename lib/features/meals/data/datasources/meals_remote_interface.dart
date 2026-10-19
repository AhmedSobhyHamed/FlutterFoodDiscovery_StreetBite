import 'package:flutterfooddiscovery_streetbite/features/meals/data/models/category_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/models/meal_model.dart';

abstract interface class MealsRemoteInterface {
  Future<List<CategoryModel>> getCategories();

  Future<List<MealModel>> getMealsByCategory(String category);

  Future<List<MealModel>> getHotOffers();

  Future<MealModel> getMealDetails(String id);
}
