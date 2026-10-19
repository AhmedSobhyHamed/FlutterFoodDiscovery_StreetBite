import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/app_api_endpoints.dart';

class MealsApi {
  static const String categories = '${AppApiEndpoints.apiV1Url}/1/categories.php';
  static const String random = '${AppApiEndpoints.apiV1Url}/1/random.php';
  static const String filter = '${AppApiEndpoints.apiV1Url}/1/filter.php';
  static const String lookup = '${AppApiEndpoints.apiV1Url}/1/lookup.php';

  static const String categoriesCache = 'meals/categories';
  static const String offersCache = 'meals/offers';
  static const String detailsCache = 'meals/lookup';
  static const String selectedCategoryCache = 'meals/selected-category';
  static const String selectedCategoryId = 'current';

  static String mealsCache(String category) => 'meals/filter/$category';
}
