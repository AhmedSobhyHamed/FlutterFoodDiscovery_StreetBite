import 'package:equatable/equatable.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';

abstract class mealDetailsStatus extends Equatable {
  const mealDetailsStatus();

  @override
  List<Object?> get props => [];
}

class mealDetailsStatusIdle extends mealDetailsStatus {
  const mealDetailsStatusIdle();
}

class mealDetailsStatusLoading extends mealDetailsStatus {
  const mealDetailsStatusLoading();
}

class mealDetailsStatusSuccess extends mealDetailsStatus {
  const mealDetailsStatusSuccess({required this.meal});

  final MealEntity meal;

  @override
  List<Object?> get props => [meal];
}

class mealDetailsStatusError extends mealDetailsStatus {
  const mealDetailsStatusError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
