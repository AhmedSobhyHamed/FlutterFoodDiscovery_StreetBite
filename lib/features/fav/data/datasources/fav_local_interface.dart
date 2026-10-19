import 'package:flutterfooddiscovery_streetbite/features/fav/data/models/fav_item_model.dart';

abstract interface class FavLocalInterface {
  Future<List<FavItemModel>> getItems();

  Future<void> add({
    required String id,
    required String name,
    required String thumb,
    String? place,
  });

  Future<void> remove(String id);
}
