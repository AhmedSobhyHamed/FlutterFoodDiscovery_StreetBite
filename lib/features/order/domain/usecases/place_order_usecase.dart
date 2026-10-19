import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/l10n/cart_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/domain/entities/order_line_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/order/domain/repositories/order_repository_interface.dart';

class PlaceOrderParams {
  const PlaceOrderParams();
}

class PlaceOrderUsecase extends BaseUsecase<List<CartItemEntity>, PlaceOrderParams> {
  PlaceOrderUsecase({required CartRepositoryInterface cart, required OrderRepositoryInterface orders})
    : _cart = cart,
      _orders = orders;

  final CartRepositoryInterface _cart;
  final OrderRepositoryInterface _orders;

  @override
  Future<Either<List<CartItemEntity>, AppException>> call(PlaceOrderParams params) async {
    final cart = await _cart.getItems();
    if (cart.isRight()) {
      return Right(GeneralException(message: cart.fold((_) => '', (message) => message)));
    }
    final items = cart.fold((value) => value, (_) => <CartItemEntity>[]);
    if (items.isEmpty) {
      return Right(GeneralException(message: CartLocale.empty));
    }
    final created = await _orders.create([
      for (final item in items) OrderLineEntity(mealId: item.id, quantity: item.quantity),
    ]);
    if (created.isRight()) {
      return Right(GeneralException(message: created.fold((_) => '', (message) => message)));
    }
    final cleared = await _cart.clear();
    return cleared.fold(Left.new, (message) => Right(GeneralException(message: message)));
  }
}
