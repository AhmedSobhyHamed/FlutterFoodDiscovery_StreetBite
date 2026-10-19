import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/core/usecases/base_usecases.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/auth_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/repositories/profile_repository_interface.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}

class LoginWithEmailPasswordUsecase extends BaseUsecase<bool, LoginParams> {
  LoginWithEmailPasswordUsecase(this._repository, this._profiles);

  final AuthRepositoryInterface _repository;
  final ProfileRepositoryInterface _profiles;

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
    if (result.isRight()) {
      return Right(GeneralException(message: result.fold((_) => '', (message) => message)));
    }
    return _storeAccount(name: '', email: params.email);
  }

  Future<Either<bool, AppException>> _storeAccount({
    required String name,
    required String email,
  }) async {
    final current = await _repository.getCurrentUser();
    if (current.isRight()) {
      return Right(GeneralException(message: current.fold((_) => '', (message) => message)));
    }
    final user = current.fold((value) => value, (_) => null);
    if (user == null) {
      return Right(GeneralException(message: AuthLocale.userNotFound));
    }
    final saved = await _profiles.saveAccount(
      id: user.id,
      name: name.isEmpty ? user.name : name,
      email: email.isEmpty ? user.email : email,
    );
    if (saved.isRight()) {
      await _repository.signOut();
      return Right(GeneralException(message: saved.fold((_) => '', (message) => message)));
    }
    return const Left(true);
  }
}
