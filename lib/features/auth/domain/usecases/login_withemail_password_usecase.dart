import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/auth_locale.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}

class LoginWithEmailPasswordUsecase extends BaseUsecase<bool, LoginParams> {
  LoginWithEmailPasswordUsecase(this._repository);

  final AuthRepositoryInterface _repository;

  @override
  Future<Either<bool, AppException>> call(LoginParams params) async {
    if (params.email.isEmpty || params.password.isEmpty) {
      return Right(
        GeneralException(message: AuthLocale.emailPasswordRequired),
      );
    }
    final currentUser = await _repository.getCurrentUser();
    if (currentUser.isLeft()) {
      return Right(GeneralException(message: AuthLocale.alreadyLoggedIn));
    }
    final result = await _repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
    return result.fold(
      Left.new,
      (message) => Right(GeneralException(message: message)),
    );
  }
}
