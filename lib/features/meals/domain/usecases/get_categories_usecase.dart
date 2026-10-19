import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/entities/category_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/repositories/meals_repository_interface.dart';

class GetCategoriesParams {
  const GetCategoriesParams();
}

class GetCategoriesUsecase extends BaseUsecase<List<CategoryEntity>, GetCategoriesParams> {
  GetCategoriesUsecase(this._repository);

  final MealsRepositoryInterface _repository;

  @override
  Future<Either<List<CategoryEntity>, AppException>> call(GetCategoriesParams params) async {
    final result = await _repository.getCategories();
    return result.fold(
      Left.new,
      (message) => Right(GeneralException(message: message)),
    );
  }
}
