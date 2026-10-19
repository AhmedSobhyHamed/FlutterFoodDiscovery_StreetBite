import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.name,
    required super.thumb,
    required super.quantity,
    super.place,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final rawQuantity = json['quantity'];
    final quantity = rawQuantity is int
        ? rawQuantity
        : int.tryParse('$rawQuantity') ?? CartItemEntity.minQuantity;
    return CartItemModel(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      thumb: '${json['thumb'] ?? ''}',
      place: json['place']?.toString(),
      quantity: quantity.clamp(CartItemEntity.minQuantity, CartItemEntity.maxQuantity).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumb': thumb,
      'place': place,
      'quantity': quantity,
    };
  }
}
