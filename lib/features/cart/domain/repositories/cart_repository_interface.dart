import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';

abstract interface class CartRepositoryInterface {
  Future<Either<List<CartItemEntity>, String>> getItems();

  Future<Either<List<CartItemEntity>, String>> addNew({
    required String id,
    required String name,
    required String thumb,
    String? place,
  });

  Future<Either<List<CartItemEntity>, String>> addOrCreate({
    required String id,
    required String name,
    required String thumb,
    String? place,
  });

  Future<Either<List<CartItemEntity>, String>> setQuantity(String id, int quantity);

  Future<Either<List<CartItemEntity>, String>> remove(String id);

  Future<Either<List<CartItemEntity>, String>> clear();
}
