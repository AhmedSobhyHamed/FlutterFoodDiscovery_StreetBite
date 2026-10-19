import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/category_entite.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.thumb,
    super.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['idCategory']?.toString() ?? json['id']?.toString() ?? '',
      name: json['strCategory']?.toString() ?? json['name']?.toString() ?? '',
      thumb: json['strCategoryThumb']?.toString() ?? json['thumb']?.toString() ?? '',
      description: _text(json['strCategoryDescription'] ?? json['description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCategory': id,
      'strCategory': name,
      'strCategoryThumb': thumb,
      'strCategoryDescription': description,
    };
  }

  static String? _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty || text == 'null') return null;
    return text;
  }
}
