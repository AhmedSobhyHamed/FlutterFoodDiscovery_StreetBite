import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/local_data_source.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/data/api/fav_api.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/data/datasources/fav_local_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/data/models/fav_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavViaLocal extends LocalDataSource implements FavLocalInterface {
  FavViaLocal(SharedPreferences preferences) : super(preferences);

  @override
  Future<List<FavItemModel>> getItems() async {
    final stored = await getList(FavApi.itemsCache);
    return stored.fold((data) {
      return data.map(FavItemModel.fromJson).toList();
    }, (error) {
      if (error.message == 'no data found') return <FavItemModel>[];
      throw error;
    });
  }

  @override
  Future<void> add({
    required String id,
    required String name,
    required String thumb,
    String? place,
  }) async {
    final stored = await post(FavApi.itemsCache, {
      'id': id,
      'name': name,
      'thumb': thumb,
      'place': place,
    });
    stored.fold((_) {}, (error) {
      throw error;
    });
  }

  @override
  Future<void> remove(String id) async {
    final stored = await delete(FavApi.itemsCache, id);
    stored.fold((_) {}, (error) {
      throw error;
    });
  }
}
