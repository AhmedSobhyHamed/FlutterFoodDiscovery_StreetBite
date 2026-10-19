import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/repositories/meals_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/l10n/meals_locale.dart';

class GetMealsByCategoryParams {
  const GetMealsByCategoryParams({required this.category});

  final String category;
}

class GetMealsByCategoryUsecase extends BaseUsecase<List<MealEntity>, GetMealsByCategoryParams> {
  GetMealsByCategoryUsecase(this._repository);

  final MealsRepositoryInterface _repository;

  @override
  Future<Either<List<MealEntity>, AppException>> call(GetMealsByCategoryParams params) async {
    if (params.category.isEmpty) {
      return Right(GeneralException(message: MealsLocale.categoryRequired));
    }
    final result = await _repository.getMealsByCategory(params.category);
    return result.fold(
      Left.new,
      (message) => Right(GeneralException(message: message)),
    );
  }
}
