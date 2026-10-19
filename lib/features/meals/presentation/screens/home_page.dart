import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/di/injection.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/l10n/meals_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/blocs/home_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/blocs/home_status.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/screens/details_page.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/widgets/category_part.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/widgets/meals_part.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/widgets/offers_part.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openMeal(MealEntity meal) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MealDetailsPage(mealId: meal.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, homeStatus>(
          builder: (context, state) {
            if (state is homeStatusError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message.getString(context),
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    TextButton(
                      onPressed: () => context.read<HomeCubit>().load(),
                      child: Text(MealsLocale.retry.getString(context)),
                    ), // TextButton
                  ], // children
                ), // Column
              ); // Center
            } // homeStatusError
            if (state is! homeStatusLoaded) {
              return const Center(child: CircularProgressIndicator(color: AppColors.green));
            }
            final query = _searchController.text.trim().toLowerCase();
            final meals = query.isEmpty
                ? state.meals
                : state.meals
                    .where((meal) => meal.name.toLowerCase().contains(query))
                    .toList();
            return RefreshIndicator(
              color: AppColors.green,
              onRefresh: () => context.read<HomeCubit>().refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.green),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        MealsLocale.location.getString(context),
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.notifications_none, color: AppColors.black),
                    const SizedBox(width: 12),
                    const Icon(Icons.shopping_cart_outlined, color: AppColors.black),
                  ], // children
                ), // Row
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: AppColors.black),
                  decoration: InputDecoration(
                    hintText: MealsLocale.searchHint.getString(context),
                    hintStyle: const TextStyle(color: AppColors.grayDark),
                    prefixIcon: const Icon(Icons.search, color: AppColors.grayDark),
                    filled: true,
                    fillColor: AppColors.grayLight,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ), // OutlineInputBorder
                  ), // InputDecoration
                ), // TextField
                const SizedBox(height: 20),
                // category then meals then hot offers
                CategoryPart(
                  categories: state.categories,
                  selectedCategory: state.selectedCategory,
                  onSelected: context.read<HomeCubit>().selectCategory,
                ), // CategoryPart
                const SizedBox(height: 20),
                OffersPart(
                  offers: state.offers,
                  message: state.offersMessage,
                  onMealTap: _openMeal,
                ), // OffersPart
                MealsPart(
                  meals: meals,
                  loading: state.mealsLoading,
                  message: state.mealsMessage,
                  onMealTap: _openMeal,
                ), // MealsPart
                const SizedBox(height: 28),
                ],
              ), // ListView
            ); // RefreshIndicator
          }, // builder
        ), // BlocBuilder
      ), // SafeArea
    ); // Scaffold
  } // build
} // _HomeView
