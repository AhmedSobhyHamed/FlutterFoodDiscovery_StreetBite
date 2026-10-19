import 'package:flutterfooddiscovery_streetbite/features/cart/data/datasources/cart_local_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/data/datasources/cart_via_local.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/data/repositories/cart_repository.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/usecases/add_cart_item_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/usecases/set_cart_quantity_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/presentation/blocs/cart_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupCartDependencies() async {
  final preferences = await SharedPreferences.getInstance();

  getIt.registerSingleton<CartLocalInterface>(CartViaLocal(preferences));
  getIt.registerSingleton<CartRepositoryInterface>(
    CartRepository(local: getIt<CartLocalInterface>()),
  );

  getIt.registerFactory<GetCartUsecase>(
    () => GetCartUsecase(getIt<CartRepositoryInterface>()),
  );
  getIt.registerFactory<AddCartItemUsecase>(
    () => AddCartItemUsecase(getIt<CartRepositoryInterface>()),
  );
  getIt.registerFactory<SetCartQuantityUsecase>(
    () => SetCartQuantityUsecase(getIt<CartRepositoryInterface>()),
  );
  getIt.registerFactory<RemoveCartItemUsecase>(
    () => RemoveCartItemUsecase(getIt<CartRepositoryInterface>()),
  );
  getIt.registerFactory<CartCubit>(
    () => CartCubit(
      getIt<GetCartUsecase>(),
      getIt<AddCartItemUsecase>(),
      getIt<SetCartQuantityUsecase>(),
      getIt<RemoveCartItemUsecase>(),
    ),
  );
}
