import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/data/datasources/fav_local_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/entities/fav_item_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/repositories/fav_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/l10n/fav_locale.dart';

class FavRepository implements FavRepositoryInterface {
  FavRepository({required FavLocalInterface local}) : _local = local;

  final FavLocalInterface _local;

  @override
  Future<Either<List<FavItemEntity>, String>> getItems() {
    return _guard(() async {
      final items = await _local.getItems();
      return items.cast<FavItemEntity>();
    }, FavLocale.loadFailed);
  }

  @override
  Future<Either<List<FavItemEntity>, String>> add({
    required String id,
    required String name,
    required String thumb,
    String? place,
  }) async {
    final current = await getItems();
    return current.fold<Future<Either<List<FavItemEntity>, String>>>((items) async {
      if (items.any((item) => item.id == id)) return Left(items);
      return _guard(() async {
        await _local.add(id: id, name: name, thumb: thumb, place: place);
        final stored = await _local.getItems();
        return stored.cast<FavItemEntity>();
      }, FavLocale.saveFailed);
    }, (message) async => Right(message));
  }

  @override
  Future<Either<List<FavItemEntity>, String>> remove(String id) {
    return _guard(() async {
      await _local.remove(id);
      final items = await _local.getItems();
      return items.cast<FavItemEntity>();
    }, FavLocale.saveFailed);
  }

  Future<Either<List<FavItemEntity>, String>> _guard(
    Future<List<FavItemEntity>> Function() action,
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
