import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
    this.wide = false,
  });

  final MealEntity meal;
  final VoidCallback onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final subtitle = meal.country ?? meal.area;
    return SizedBox(
      width: wide ? 240 : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                meal.thumb,
                height: wide ? 140 : 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: wide ? 140 : 150,
                  color: AppColors.grayLight,
                ), // Container
              ), // Image.network
            ), // ClipRRect
            const SizedBox(height: 8),
            Text(
              meal.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ), // TextStyle
            ), // ClipRRect
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.grayDark, fontSize: 13),
              ), // Text
            ], // if
          ], // children
        ), // Column
      ), // InkWell
    ); // SizedBox
  } // build
} // MealCard
