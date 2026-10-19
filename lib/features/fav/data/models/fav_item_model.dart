import 'package:flutterfooddiscovery_streetbite/features/fav/domain/entities/fav_item_entite.dart';

class FavItemModel extends FavItemEntity {
  const FavItemModel({
    required super.id,
    required super.name,
    required super.thumb,
    super.place,
  });

  factory FavItemModel.fromJson(Map<String, dynamic> json) {
    return FavItemModel(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      thumb: '${json['thumb'] ?? ''}',
      place: json['place']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumb': thumb,
      'place': place,
    };
  }
}
