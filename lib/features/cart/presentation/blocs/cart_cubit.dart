import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/usecases/add_cart_item_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/usecases/set_cart_quantity_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/presentation/blocs/cart_status.dart';

class CartCubit extends Cubit<cartStatus> {
  CartCubit(this._getCart, this._addItem, this._setQuantity, this._removeItem)
    : super(const cartStatusIdle());

  final GetCartUsecase _getCart;
  final AddCartItemUsecase _addItem;
  final SetCartQuantityUsecase _setQuantity;
  final RemoveCartItemUsecase _removeItem;
  Future<void> _pending = Future<void>.value();

  Future<void> load() {
    return _run(() async {
      emit(const cartStatusLoading());
      final result = await _getCart.call(const GetCartParams());
      _emit(result);
    });
  }

  Future<void> add({
    required String id,
    required String name,
    required String thumb,
    String? place,
  }) {
    return _run(() async {
      final result = await _addItem.call(
        AddCartItemParams(id: id, name: name, thumb: thumb, place: place),
      );
      _emit(result);
    });
  }

  Future<void> increase(String id) {
    return _run(() async {
      final item = _item(id);
      if (item == null || item.quantity >= CartItemEntity.maxQuantity) return;
      final result = await _setQuantity.call(
        SetCartQuantityParams(id: id, quantity: item.quantity + 1),
      );
      _emit(result);
    });
  }

  Future<void> decrease(String id) {
    return _run(() async {
      final item = _item(id);
      if (item == null || item.quantity <= CartItemEntity.minQuantity) return;
      final result = await _setQuantity.call(
        SetCartQuantityParams(id: id, quantity: item.quantity - 1),
      );
      _emit(result);
    });
  }

  Future<void> remove(String id) {
    return _run(() async {
      final result = await _removeItem.call(RemoveCartItemParams(id: id));
      _emit(result);
    });
  }

  Future<void> _run(Future<void> Function() action) {
    final run = _pending.then((_) => action());
    _pending = run.then<void>((_) {}, onError: (Object _) {});
    return run;
  }

  CartItemEntity? _item(String id) {
    final current = state;
    if (current is! cartStatusLoaded) return null;
    for (final item in current.items) {
      if (item.id == id) return item;
    }
    return null;
  }

  void _emit(Either<List<CartItemEntity>, AppException> result) {
    if (isClosed) return;
    result.fold((items) => emit(cartStatusLoaded(items: items)), (error) {
      final current = state;
      if (current is cartStatusLoaded) {
        emit(cartStatusLoaded(items: current.items, message: error.message));
        return;
      }
      emit(cartStatusError(message: error.message));
    });
  }
}
