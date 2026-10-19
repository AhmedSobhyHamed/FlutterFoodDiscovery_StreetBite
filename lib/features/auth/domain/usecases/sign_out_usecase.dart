import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/repositories/auth_repository_interface.dart';

class SignOutParams {
  const SignOutParams();
}

class SignOutUsecase extends BaseUsecase<bool, SignOutParams> {
  SignOutUsecase(this._repository);

  final AuthRepositoryInterface _repository;

  @override
  Future<Either<bool, AppException>> call(SignOutParams params) async {
    final result = await _repository.signOut();
    return result.fold(
      Left.new,
      (message) => Right(GeneralException(message: message)),
    );
  }
}
