import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/usecases/get_meal_details_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/blocs/meal_details_status.dart';

class MealDetailsCubit extends Cubit<mealDetailsStatus> {
  MealDetailsCubit(this._getMealDetails) : super(const mealDetailsStatusIdle());

  final GetMealDetailsUsecase _getMealDetails;

  Future<void> load(String id) async {
    emit(const mealDetailsStatusLoading());
    final result = await _getMealDetails.call(GetMealDetailsParams(id: id));
    if (isClosed) return;
    result.fold(
      (meal) => emit(mealDetailsStatusSuccess(meal: meal)),
      (error) => emit(mealDetailsStatusError(message: error.message)),
    );
  }
}
