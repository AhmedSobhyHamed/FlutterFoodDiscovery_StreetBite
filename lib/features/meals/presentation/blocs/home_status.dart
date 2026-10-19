import 'package:equatable/equatable.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/category_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';

abstract class homeStatus extends Equatable {
  const homeStatus();

  @override
  List<Object?> get props => [];
}

class homeStatusIdle extends homeStatus {
  const homeStatusIdle();
}

class homeStatusLoading extends homeStatus {
  const homeStatusLoading();
}

class homeStatusError extends homeStatus {
  const homeStatusError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class homeStatusLoaded extends homeStatus {
  const homeStatusLoaded({
    required this.categories,
    required this.selectedCategory,
    required this.meals,
    required this.offers,
    this.mealsLoading = false,
    this.mealsMessage,
    this.offersMessage,
  });

  final List<CategoryEntity> categories;
  final String selectedCategory;
  final List<MealEntity> meals;
  final List<MealEntity> offers;
  final bool mealsLoading;
  final String? mealsMessage;
  final String? offersMessage;

  @override
  List<Object?> get props => [
    categories,
    selectedCategory,
    meals,
    offers,
    mealsLoading,
    mealsMessage,
    offersMessage,
  ];
}
