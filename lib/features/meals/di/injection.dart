import 'package:dio/dio.dart';
import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/app_api_endpoints.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/datasources/meals_local_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/datasources/meals_remote_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/datasources/meals_via_local.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/datasources/meals_via_remote.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/data/repositories/meals_repository.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/repositories/meals_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/usecases/get_categories_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/usecases/get_hot_offers_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/usecases/get_meal_details_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/usecases/get_meals_by_category_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/usecases/selected_category_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/blocs/home_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/blocs/meal_details_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupMealsDependencies() async {
  final preferences = await SharedPreferences.getInstance();

  getIt.registerSingleton<MealsLocalInterface>(MealsViaLocal(preferences));
  getIt.registerSingleton<MealsRemoteInterface>(
    MealsViaRemote(Dio(BaseOptions(baseUrl: AppApiEndpoints.baseUrl))),
  );
  getIt.registerSingleton<MealsRepositoryInterface>(
    MealsRepository(
      local: getIt<MealsLocalInterface>(),
      remote: getIt<MealsRemoteInterface>(),
    ),
  );

  getIt.registerFactory<GetCategoriesUsecase>(
    () => GetCategoriesUsecase(getIt<MealsRepositoryInterface>()),
  );
  getIt.registerFactory<GetMealsByCategoryUsecase>(
    () => GetMealsByCategoryUsecase(getIt<MealsRepositoryInterface>()),
  );
  getIt.registerFactory<GetHotOffersUsecase>(
    () => GetHotOffersUsecase(getIt<MealsRepositoryInterface>()),
  );
  getIt.registerFactory<GetMealDetailsUsecase>(
    () => GetMealDetailsUsecase(getIt<MealsRepositoryInterface>()),
  );
  getIt.registerFactory<GetSelectedCategoryUsecase>(
    () => GetSelectedCategoryUsecase(getIt<MealsRepositoryInterface>()),
  );
  getIt.registerFactory<SaveSelectedCategoryUsecase>(
    () => SaveSelectedCategoryUsecase(getIt<MealsRepositoryInterface>()),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      getIt<GetCategoriesUsecase>(),
      getIt<GetMealsByCategoryUsecase>(),
      getIt<GetHotOffersUsecase>(),
      getIt<GetSelectedCategoryUsecase>(),
      getIt<SaveSelectedCategoryUsecase>(),
    ),
  );
  getIt.registerFactory<MealDetailsCubit>(
    () => MealDetailsCubit(getIt<GetMealDetailsUsecase>()),
  );
}
