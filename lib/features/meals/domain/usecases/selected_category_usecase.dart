import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/repositories/meals_repository_interface.dart';

class GetSelectedCategoryParams {
  const GetSelectedCategoryParams();
}

class GetSelectedCategoryUsecase extends BaseUsecase<String, GetSelectedCategoryParams> {
  GetSelectedCategoryUsecase(this._repository);

  final MealsRepositoryInterface _repository;

  @override
  Future<Either<String, AppException>> call(GetSelectedCategoryParams params) async {
    final category = await _repository.getSelectedCategory();
    return Left(category ?? '');
  }
}

class SaveSelectedCategoryParams {
  const SaveSelectedCategoryParams({required this.category});

  final String category;
}

class SaveSelectedCategoryUsecase extends BaseUsecase<bool, SaveSelectedCategoryParams> {
  SaveSelectedCategoryUsecase(this._repository);

  final MealsRepositoryInterface _repository;

  @override
  Future<Either<bool, AppException>> call(SaveSelectedCategoryParams params) async {
    await _repository.saveSelectedCategory(params.category);
    return const Left(true);
  }
}
