import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/data/datasources/cart_local_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/entities/cart_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/l10n/cart_locale.dart';

class CartRepository implements CartRepositoryInterface {
  CartRepository({required CartLocalInterface local}) : _local = local;

  final CartLocalInterface _local;

  @override
  Future<Either<List<CartItemEntity>, String>> getItems() {
    return _guard(() async {
      final items = await _local.getItems();
      return items.cast<CartItemEntity>();
    }, CartLocale.loadFailed);
  }

  @override
  Future<Either<List<CartItemEntity>, String>> addNew({
    required String id,
    required String name,
    required String thumb,
    String? place,
  }) {
    return _guard(() async {
      await _local.create(id: id, name: name, thumb: thumb, place: place);
      final items = await _local.getItems();
      return items.cast<CartItemEntity>();
    }, CartLocale.saveFailed);
  }

  @override
  Future<Either<List<CartItemEntity>, String>> addOrCreate({
    required String id,
    required String name,
    required String thumb,
    String? place,
  }) async {
    final current = await getItems();
    return current.fold<Future<Either<List<CartItemEntity>, String>>>((items) async {
      for (final item in items) {
        if (item.id != id) continue;
        if (item.quantity >= CartItemEntity.maxQuantity) {
          return Right(CartLocale.saveFailed);
        }
        return setQuantity(id, item.quantity + 1);
      }
      return addNew(id: id, name: name, thumb: thumb, place: place);
    }, (message) async => Right(message));
  }

  @override
  Future<Either<List<CartItemEntity>, String>> setQuantity(String id, int quantity) {
    return _guard(() async {
      await _local.setQuantity(id, quantity);
      final items = await _local.getItems();
      return items.cast<CartItemEntity>();
    }, CartLocale.saveFailed);
  }

  @override
  Future<Either<List<CartItemEntity>, String>> remove(String id) {
    return _guard(() async {
      await _local.remove(id);
      final items = await _local.getItems();
      return items.cast<CartItemEntity>();
    }, CartLocale.saveFailed);
  }

  @override
  Future<Either<List<CartItemEntity>, String>> clear() {
    return _guard(() async {
      await _local.clear();
      final items = await _local.getItems();
      return items.cast<CartItemEntity>();
    }, CartLocale.saveFailed);
  }

  Future<Either<List<CartItemEntity>, String>> _guard(
    Future<List<CartItemEntity>> Function() action,
    String fallback,
  ) async {
    try {
      final items = await action();
      return Left(items);
    } on AppException catch (error) {
      return Right(error.message);
    } catch (_) {
      return Right(fallback);
    }
  }
}
