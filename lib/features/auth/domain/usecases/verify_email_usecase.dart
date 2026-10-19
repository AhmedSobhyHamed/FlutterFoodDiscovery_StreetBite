import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/repositories/auth_repository_interface.dart';

class VerifyEmailParams {
  const VerifyEmailParams();
}

class VerifyEmailUsecase extends BaseUsecase<bool, VerifyEmailParams> {
  VerifyEmailUsecase(this._repository);

  final AuthRepositoryInterface _repository;

  @override
  Future<Either<bool, AppException>> call(VerifyEmailParams params) async {
    final result = await _repository.verifyEmail();
    return result.fold(
      Left.new,
      (message) => Right(GeneralException(message: message)),
    );
  }
}
