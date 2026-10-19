import 'package:flutterfooddiscovery_streetbite/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/data/datasources/order_remote_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/data/datasources/order_via_firestore.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/data/repositories/order_repository.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/domain/repositories/order_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/domain/usecases/place_order_usecase.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupOrderDependencies() {
  getIt.registerSingleton<OrderRemoteInterface>(OrderViaFirestore());
  getIt.registerSingleton<OrderRepositoryInterface>(
    OrderRepository(remote: getIt<OrderRemoteInterface>()),
  );
  getIt.registerFactory<PlaceOrderUsecase>(
    () => PlaceOrderUsecase(
      cart: getIt<CartRepositoryInterface>(),
      orders: getIt<OrderRepositoryInterface>(),
    ),
  );
}
