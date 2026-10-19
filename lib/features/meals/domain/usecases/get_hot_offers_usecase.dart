import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/meal_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/repositories/meals_repository_interface.dart';

class GetHotOffersParams {
  const GetHotOffersParams();
}

class GetHotOffersUsecase extends BaseUsecase<List<MealEntity>, GetHotOffersParams> {
  GetHotOffersUsecase(this._repository);

  final MealsRepositoryInterface _repository;

  @override
  Future<Either<List<MealEntity>, AppException>> call(GetHotOffersParams params) async {
    final result = await _repository.getHotOffers();
    return result.fold(
      Left.new,
      (message) => Right(GeneralException(message: message)),
    );
  }
}
