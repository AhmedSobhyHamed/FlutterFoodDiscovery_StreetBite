import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/core/widgets/add_button.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/l10n/cart_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/presentation/blocs/cart_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/presentation/blocs/fav_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/presentation/blocs/fav_status.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/di/injection.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/l10n/meals_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/blocs/meal_details_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/blocs/meal_details_status.dart';

class MealDetailsPage extends StatelessWidget {
  const MealDetailsPage({super.key, required this.mealId});

  final String mealId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MealDetailsCubit>()..load(mealId),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
          actions: const [
            _FavoriteButton(),
          ],
        ),
        body: BlocBuilder<MealDetailsCubit, mealDetailsStatus>(
          builder: (context, state) {
            if (state is mealDetailsStatusError) {
              return Center(
                child: Text(
                  state.message.getString(context),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ), // Text
              ); // Center
            } // mealDetailsStatusError
            if (state is! mealDetailsStatusSuccess) {
              return const Center(child: CircularProgressIndicator(color: AppColors.green));
            } // mealDetailsStatusSuccess
            final meal = state.meal;
            final place = [meal.category, meal.area, meal.country].whereType<String>().join(' · ');
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    meal.thumb,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 220,
                      color: AppColors.grayLight,
                    ), // errorBuilder
                  ), // Image.network
                ), // ClipRRect
                const SizedBox(height: 16),
                Text(
                  meal.name,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ), // TextStyle
                ), // Text
                if (place.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(place, style: const TextStyle(color: AppColors.green, fontSize: 15)),
                ], // if
                if (meal.ingredients.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    MealsLocale.ingredients.getString(context),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ), // TextStyle
                  ), // Text
                  const SizedBox(height: 8),
                  ...meal.ingredients.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        item.measure.isEmpty ? item.name : '${item.measure}  ${item.name}',
                        style: const TextStyle(color: AppColors.black, fontSize: 15),
                      ), // Text
                    ), // Padding
                  ), // map
                ],
                if (meal.instructions != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    MealsLocale.instructions.getString(context),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ), // TextStyle
                  ), // Text
                  const SizedBox(height: 8),
                  Text(
                    meal.instructions!,
                    style: const TextStyle(color: AppColors.black, fontSize: 15, height: 1.4),
                  ), // Text
                ], // if
                const SizedBox(height: 24),
                AddButton(
                  showLabel: true,
                  label: CartLocale.add.getString(context),
                  onPressed: () => context.read<CartCubit>().add(
                    id: meal.id,
                    name: meal.name,
                    thumb: meal.thumb,
                    place: _mealPlace(meal),
                  ),
                ),
              ], // children
            ); // ListView
          }, // builder
        ), // BlocBuilder
      ), // Scaffold
    ); // MealDetailsPage
  } // build
} // MealDetailsPage

String? _mealPlace(MealEntity meal) {
  final parts = [meal.area, meal.country].whereType<String>().where((part) => part.isNotEmpty);
  if (parts.isNotEmpty) return parts.join(' · ');
  final category = meal.category;
  if (category == null || category.isEmpty) return null;
  return category;
} // _mealPlace

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealDetailsCubit, mealDetailsStatus>(
      builder: (context, state) {
        if (state is! mealDetailsStatusSuccess) return const SizedBox.shrink();
        final meal = state.meal;
        return BlocBuilder<FavCubit, favStatus>(
          builder: (context, favState) {
            final saved = favState is favStatusLoaded && favState.contains(meal.id);
            return IconButton(
              onPressed: () {
                final fav = context.read<FavCubit>();
                if (saved) {
                  fav.remove(meal.id);
                  return;
                }
                fav.add(
                  id: meal.id,
                  name: meal.name,
                  thumb: meal.thumb,
                  place: _mealPlace(meal),
                );
              }, // onPressed
              icon: Icon(
                saved ? Icons.favorite : Icons.favorite_border,
                color: AppColors.green,
              ),
            ); // IconButton
          }, // builder
        ); // BlocBuilder
      }, // builder
    ); // BlocBuilder
  } // build
} // _FavoriteButton
