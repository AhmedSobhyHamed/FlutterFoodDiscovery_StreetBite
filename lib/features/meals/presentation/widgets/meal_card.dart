import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/core/widgets/add_button.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/l10n/cart_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/presentation/blocs/cart_cubit.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                meal.thumb,
                height: wide ? 140 : 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: wide ? 140 : 150,
                  color: AppColors.grayLight,
                ), // errorBuilder
              ), // Image.network
            ), // ClipRRect
          ), // InkWell
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ), // TextStyle
                      ),
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
              ), // Expanded
              AddButton(
                tooltip: CartLocale.add.getString(context),
                onPressed: () => context.read<CartCubit>().add(
                  id: meal.id,
                  name: meal.name,
                  thumb: meal.thumb,
                  place: subtitle,
                ),
              ), // AddButton
            ], // children
          ), // Row
        ], // children
      ), // Column
    ); // SizedBox
  } // build
} // MealCard
