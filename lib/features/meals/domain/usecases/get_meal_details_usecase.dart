import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/repositories/meals_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/l10n/meals_locale.dart';

class GetMealDetailsParams {
  const GetMealDetailsParams({required this.id});

  final String id;
}

class GetMealDetailsUsecase extends BaseUsecase<MealEntity, GetMealDetailsParams> {
  GetMealDetailsUsecase(this._repository);

  final MealsRepositoryInterface _repository;

  @override
  Future<Either<MealEntity, AppException>> call(GetMealDetailsParams params) async {
    if (params.id.isEmpty) {
      return Right(GeneralException(message: MealsLocale.notFound));
    }
    final result = await _repository.getMealDetails(params.id);
    return result.fold(
      Left.new,
      (message) => Right(GeneralException(message: message)),
    );
  }
}
