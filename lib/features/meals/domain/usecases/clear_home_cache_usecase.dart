import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/domain/repositories/meals_repository_interface.dart';

class ClearHomeCacheParams {
  const ClearHomeCacheParams();
}

class ClearHomeCacheUsecase extends BaseUsecase<bool, ClearHomeCacheParams> {
  ClearHomeCacheUsecase(this._repository);

  final MealsRepositoryInterface _repository;

  @override
  Future<Either<bool, AppException>> call(ClearHomeCacheParams params) async {
    final result = await _repository.clearHome();
    return result.fold(
      Left.new,
      (message) => Right(GeneralException(message: message)),
    );
  }
}
