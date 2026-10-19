import 'package:equatable/equatable.dart';

class MealIngredient extends Equatable {
  final String name;
  final String measure;

  const MealIngredient({required this.name, required this.measure});

  @override
  List<Object?> get props => [name, measure];
}

class MealEntity extends Equatable {
  final String id;
  final String name;
  final String thumb;
  final String? area;
  final String? country;
  final String? category;
  final String? instructions;
  final String? tags;
  final String? youtube;
  final List<MealIngredient> ingredients;

  const MealEntity({
    required this.id,
    required this.name,
    required this.thumb,
    this.area,
    this.country,
    this.category,
    this.instructions,
    this.tags,
    this.youtube,
    this.ingredients = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    thumb,
    area,
    country,
    category,
    instructions,
    tags,
    youtube,
    ingredients,
  ];
}
