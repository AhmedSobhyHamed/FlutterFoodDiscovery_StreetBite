import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/repositories/auth_repository_interface.dart';

class GetCurrentUserParams {
  const GetCurrentUserParams();
}

class GetCurrentUserUsecase extends BaseUsecase<bool, GetCurrentUserParams> {
  GetCurrentUserUsecase(this._repository);

  final AuthRepositoryInterface _repository;

  @override
  Future<Either<bool, AppException>> call(GetCurrentUserParams params) async {
    final result = await _repository.getCurrentUser();
    return result.fold(
      (_) => const Left(true),
      (message) => Right(GeneralException(message: message)),
    );
  }
}
