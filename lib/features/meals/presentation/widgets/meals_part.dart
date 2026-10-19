import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/l10n/meals_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/widgets/meal_card.dart';

class MealsPart extends StatelessWidget {
  const MealsPart({
    super.key,
    required this.meals,
    required this.loading,
    required this.onMealTap,
    this.message,
  });

  final List<MealEntity> meals;
  final bool loading;
  final ValueChanged<MealEntity> onMealTap;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          MealsLocale.mealsTitle.getString(context),
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ), // TextStyle
        ), // TextStyle
        const SizedBox(height: 16),
        if (loading)
          const Center(child: CircularProgressIndicator(color: AppColors.green))
        else if (message != null)
          Text(
            message!.getString(context),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ) // Text
        else if (meals.isEmpty)
          Text(
            MealsLocale.emptyMeals.getString(context),
            style: const TextStyle(color: AppColors.grayDark),
          ) // Text
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: meals.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 240,
            ),
            itemBuilder: (context, index) {
              final meal = meals[index];
              return MealCard(meal: meal, onTap: () => onMealTap(meal));
            }, // itemBuilder
          ), // GridView.builder
      ], // Column
    ); // build
  } // build
} // MealsPart
