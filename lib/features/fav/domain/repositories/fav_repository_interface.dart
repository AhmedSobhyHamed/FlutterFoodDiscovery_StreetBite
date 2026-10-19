import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/domain/entities/fav_item_entite.dart';

abstract interface class FavRepositoryInterface {
  Future<Either<List<FavItemEntity>, String>> getItems();

  Future<Either<List<FavItemEntity>, String>> add({
    required String id,
    required String name,
    required String thumb,
    String? place,
  });

  Future<Either<List<FavItemEntity>, String>> remove(String id);
}
