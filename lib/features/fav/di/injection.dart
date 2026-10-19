import 'package:flutterfooddiscovery_streetbite/features/fav/data/datasources/fav_local_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/data/datasources/fav_via_local.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/data/repositories/fav_repository.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/repositories/fav_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/usecases/add_fav_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/usecases/get_fav_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/usecases/remove_fav_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/presentation/blocs/fav_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupFavDependencies() async {
  final preferences = await SharedPreferences.getInstance();

  getIt.registerSingleton<FavLocalInterface>(FavViaLocal(preferences));
  getIt.registerSingleton<FavRepositoryInterface>(
    FavRepository(local: getIt<FavLocalInterface>()),
  );

  getIt.registerFactory<GetFavUsecase>(
    () => GetFavUsecase(getIt<FavRepositoryInterface>()),
  );
  getIt.registerFactory<AddFavUsecase>(
    () => AddFavUsecase(getIt<FavRepositoryInterface>()),
  );
  getIt.registerFactory<RemoveFavUsecase>(
    () => RemoveFavUsecase(getIt<FavRepositoryInterface>()),
  );
  getIt.registerFactory<FavCubit>(
    () => FavCubit(
      getIt<GetFavUsecase>(),
      getIt<AddFavUsecase>(),
      getIt<RemoveFavUsecase>(),
    ),
  );
}
