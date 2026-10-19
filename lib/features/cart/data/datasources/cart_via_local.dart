import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/local_data_source.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/data/api/cart_api.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/data/datasources/cart_local_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/data/models/cart_item_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartViaLocal extends LocalDataSource implements CartLocalInterface {
  CartViaLocal(SharedPreferences preferences) : super(preferences);

  @override
  Future<List<CartItemModel>> getItems() async {
    final stored = await getList(CartApi.itemsCache);
    return stored.fold((data) {
      return data.map(CartItemModel.fromJson).toList();
    }, (error) {
      if (error.message == 'no data found') return <CartItemModel>[];
      throw error;
    });
  }

  @override
  Future<void> create({
    required String id,
    required String name,
    required String thumb,
    String? place,
  }) async {
    final stored = await post(CartApi.itemsCache, {
      'id': id,
      'name': name,
      'thumb': thumb,
      'place': place,
      'quantity': CartItemEntity.minQuantity,
    });
    _throwIfFailed(stored);
  }

  @override
  Future<void> setQuantity(String id, int quantity) async {
    final stored = await put(CartApi.itemsCache, id, {'quantity': quantity});
    _throwIfFailed(stored);
  }

  @override
  Future<void> remove(String id) async {
    final stored = await delete(CartApi.itemsCache, id);
    _throwIfFailed(stored);
  }

  @override
  Future<void> clear() async {
    final items = await getItems();
    for (final item in items) {
      await remove(item.id);
    }
  }

  void _throwIfFailed<T>(Either<T, AppException> stored) {
    stored.fold((_) {}, (error) {
      throw error;
    });
  }
}
