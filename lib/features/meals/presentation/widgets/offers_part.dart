import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/l10n/meals_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/widgets/meal_card.dart';

class OffersPart extends StatelessWidget {
  const OffersPart({
    super.key,
    required this.offers,
    required this.onMealTap,
    this.message,
  });

  final List<MealEntity> offers;
  final ValueChanged<MealEntity> onMealTap;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          MealsLocale.offersTitle.getString(context),
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ), // TextStyle
        ), // Text
        const SizedBox(height: 16),
        if (message != null)
          Text(
            message!.getString(context),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ) // Text
        else if (offers.isEmpty)
          const SizedBox.shrink()
        else
          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: offers.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final meal = offers[index];
                return MealCard(
                  meal: meal,
                  wide: true,
                  onTap: () => onMealTap(meal),
                );
              }, // itemBuilder
            ), // ListView.separated
          ), // SizedBox
      ], // Column
    ); // build
  } // build
} // OffersPart
