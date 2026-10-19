import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/category_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/usecases/clear_home_cache_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/usecases/get_categories_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/usecases/get_hot_offers_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/usecases/get_meals_by_category_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/usecases/selected_category_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/l10n/meals_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/blocs/home_status.dart';

class HomeCubit extends Cubit<homeStatus> {
  HomeCubit(
    this._getCategories,
    this._getMeals,
    this._getOffers,
    this._getSelectedCategory,
    this._saveSelectedCategory,
    this._clearHome,
  ) : super(const homeStatusIdle());

  final GetCategoriesUsecase _getCategories;
  final GetMealsByCategoryUsecase _getMeals;
  final GetHotOffersUsecase _getOffers;
  final GetSelectedCategoryUsecase _getSelectedCategory;
  final SaveSelectedCategoryUsecase _saveSelectedCategory;
  final ClearHomeCacheUsecase _clearHome;
  var _mealsRequest = 0;

  Future<void> load() async {
    emit(const homeStatusLoading());
    await _loadHome();
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! homeStatusLoaded) {
      await load();
      return;
    }
    final cleared = await _clearHome.call(const ClearHomeCacheParams());
    if (isClosed) return;
    final clearError = cleared.fold<String?>((_) => null, (error) => error.message);
    if (clearError != null) {
      emit(
        homeStatusLoaded(
          categories: current.categories,
          selectedCategory: current.selectedCategory,
          meals: current.meals,
          offers: current.offers,
          mealsMessage: clearError,
          offersMessage: current.offersMessage,
        ),
      );
      return;
    }
    emit(
      homeStatusLoaded(
        categories: current.categories,
        selectedCategory: current.selectedCategory,
        meals: const [],
        offers: const [],
        mealsLoading: true,
      ),
    );
    await _loadHome(previous: current);
  }

  Future<void> _loadHome({homeStatusLoaded? previous}) async {
    final categoriesResult = await _getCategories.call(const GetCategoriesParams());
    if (isClosed) return;
    await categoriesResult.fold((categories) async {
      if (categories.isEmpty) {
        _emitHomeFailure(MealsLocale.categoriesFailed, previous);
        return;
      }
      final selected = await _resolveSelected(categories);
      await _remember(selected.name);
      emit(
        homeStatusLoaded(
          categories: categories,
          selectedCategory: selected.name,
          meals: const [],
          offers: const [],
          mealsLoading: true,
        ),
      );
      // meals follow the selected category; offers load once on launch
      await Future.wait([
        _loadMeals(selected.name),
        _loadOffers(),
      ]);
    }, (error) async {
      _emitHomeFailure(error.message, previous);
    });
  }

  void _emitHomeFailure(String message, homeStatusLoaded? previous) {
    if (previous == null) {
      emit(homeStatusError(message: message));
      return;
    }
    emit(
      homeStatusLoaded(
        categories: previous.categories,
        selectedCategory: previous.selectedCategory,
        meals: previous.meals,
        offers: previous.offers,
        mealsMessage: message,
        offersMessage: previous.offersMessage,
      ),
    );
  }

  Future<void> selectCategory(CategoryEntity category) async {
    final current = state;
    if (current is! homeStatusLoaded || current.selectedCategory == category.name) return;
    emit(
      homeStatusLoaded(
        categories: current.categories,
        selectedCategory: category.name,
        meals: const [],
        offers: current.offers,
        mealsLoading: true,
        offersMessage: current.offersMessage,
      ),
    );
    await _remember(category.name);
    await _loadMeals(category.name);
  }

  Future<CategoryEntity> _resolveSelected(List<CategoryEntity> categories) async {
    final saved = await _getSelectedCategory.call(const GetSelectedCategoryParams());
    final savedName = saved.fold((name) => name, (_) => '');
    for (final category in categories) {
      if (category.name == savedName) return category;
    }
    return categories.first;
  }

  Future<void> _remember(String category) async {
    await _saveSelectedCategory.call(SaveSelectedCategoryParams(category: category));
  }

  Future<void> _loadMeals(String category) async {
    final request = ++_mealsRequest;
    final result = await _getMeals.call(GetMealsByCategoryParams(category: category));
    if (isClosed || request != _mealsRequest) return;
    final current = state;
    if (current is! homeStatusLoaded || current.selectedCategory != category) return;
    result.fold(
      (meals) => emit(
        homeStatusLoaded(
          categories: current.categories,
          selectedCategory: current.selectedCategory,
          meals: meals,
          offers: current.offers,
          offersMessage: current.offersMessage,
        ),
      ),
      (error) => emit(
        homeStatusLoaded(
          categories: current.categories,
          selectedCategory: current.selectedCategory,
          meals: const [],
          offers: current.offers,
          mealsMessage: error.message,
          offersMessage: current.offersMessage,
        ),
      ),
    );
  }

  Future<void> _loadOffers() async {
    final result = await _getOffers.call(const GetHotOffersParams());
    if (isClosed) return;
    final current = state;
    if (current is! homeStatusLoaded) return;
    result.fold(
      (offers) => emit(
        homeStatusLoaded(
          categories: current.categories,
          selectedCategory: current.selectedCategory,
          meals: current.meals,
          offers: offers,
          mealsLoading: current.mealsLoading,
          mealsMessage: current.mealsMessage,
        ),
      ),
      (error) => emit(
        homeStatusLoaded(
          categories: current.categories,
          selectedCategory: current.selectedCategory,
          meals: current.meals,
          offers: current.offers,
          mealsLoading: current.mealsLoading,
          mealsMessage: current.mealsMessage,
          offersMessage: error.message,
        ),
      ),
    );
  }
}
