import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';

class MealIngredientModel extends MealIngredient {
  const MealIngredientModel({required super.name, required super.measure});

  factory MealIngredientModel.fromJson(Map<String, dynamic> json) {
    return MealIngredientModel(
      name: json['name']?.toString() ?? '',
      measure: json['measure']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'measure': measure};
  }
}

class MealModel extends MealEntity {
  const MealModel({
    required super.id,
    required super.name,
    required super.thumb,
    super.area,
    super.country,
    super.category,
    super.instructions,
    super.tags,
    super.youtube,
    super.ingredients,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['idMeal']?.toString() ?? json['id']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? json['name']?.toString() ?? '',
      thumb: json['strMealThumb']?.toString() ?? json['thumb']?.toString() ?? '',
      area: _text(json['strArea'] ?? json['area']),
      country: _text(json['strCountry'] ?? json['country']),
      category: _text(json['strCategory'] ?? json['category']),
      instructions: _text(json['strInstructions'] ?? json['instructions']),
      tags: _text(json['strTags'] ?? json['tags']),
      youtube: _text(json['strYoutube'] ?? json['youtube']),
      ingredients: _ingredients(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': thumb,
      'strArea': area,
      'strCountry': country,
      'strCategory': category,
      'strInstructions': instructions,
      'strTags': tags,
      'strYoutube': youtube,
      'ingredients': ingredients
          .map(
            (item) => MealIngredientModel(name: item.name, measure: item.measure).toJson(),
          )
          .toList(),
    };
  }

  static List<MealIngredient> _ingredients(Map<String, dynamic> json) {
    final stored = json['ingredients'];
    if (stored is List) {
      return stored
          .whereType<Map>()
          .map((item) => MealIngredientModel.fromJson(Map<String, dynamic>.from(item)))
          .where((item) => item.name.isNotEmpty)
          .toList();
    }
    final items = <MealIngredient>[];
    for (var index = 1; index <= 20; index++) {
      final name = _text(json['strIngredient$index']);
      if (name == null) continue;
      items.add(
        MealIngredientModel(
          name: name,
          measure: _text(json['strMeasure$index']) ?? '',
        ),
      );
    }
    return items;
  }

  static String? _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty || text == 'null') return null;
    return text;
  }
}
