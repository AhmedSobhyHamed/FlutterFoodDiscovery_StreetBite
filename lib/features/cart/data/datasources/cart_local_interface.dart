import 'package:flutterfooddiscovery_streetbite/features/cart/data/models/cart_item_model.dart';

abstract interface class CartLocalInterface {
  Future<List<CartItemModel>> getItems();

  Future<void> create({
    required String id,
    required String name,
    required String thumb,
    String? place,
  });

  Future<void> setQuantity(String id, int quantity);

  Future<void> remove(String id);

  Future<void> clear();
}
