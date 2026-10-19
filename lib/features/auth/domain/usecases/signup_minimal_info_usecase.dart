import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/auth_locale.dart';

class SignupParams {
  const SignupParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

class SignupMinimalInfoUsecase extends BaseUsecase<bool, SignupParams> {
  SignupMinimalInfoUsecase(this._repository);

  final AuthRepositoryInterface _repository;

  @override
  Future<Either<bool, AppException>> call(SignupParams params) async {
    if (params.name.isEmpty || params.email.isEmpty || params.password.isEmpty) {
      return Right(
        GeneralException(message: AuthLocale.nameEmailPasswordRequired),
      );
    }
    final result = await _repository.signUpWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
    return result.fold(
      Left.new,
      (message) => Right(GeneralException(message: message)),
    );
  }
}
