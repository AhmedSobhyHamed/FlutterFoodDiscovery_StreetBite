import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/data/datasources/auth_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/data/models/user_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/entities/user_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/auth_locale.dart';

class AuthRepository implements AuthRepositoryInterface {
  AuthRepository({required AuthWithEmailAndPasswordInterface<UserModel> auth})
    : _auth = auth;

  final AuthWithEmailAndPasswordInterface<UserModel> _auth;

  @override
  Future<Either<bool, String>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _auth.signInWithEmailAndPassword(email: email, password: password),
      AuthLocale.loginFailed,
    );
  }

  @override
  Future<Either<bool, String>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) {
    return _guard(
      () => _auth.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
      AuthLocale.signupFailed,
    );
  }

  @override
  Future<Either<bool, String>> forgotPassword({required String email}) {
    return _guard(
      () => _auth.forgotPassword(email: email),
      AuthLocale.forgotPasswordFailed,
    );
  }

  @override
  Future<Either<bool, String>> verifyEmail() {
    return _guard(_auth.verifyEmail, AuthLocale.verifyEmailFailed);
  }

  @override
  Future<Either<UserEntity, String>> getCurrentUser() async {
    try {
      final user = await _auth.getCurrentUser();
      if (user == null) {
        return const Right(AuthLocale.userNotFound);
      }
      return Left(user);
    } on AppException catch (error) {
      return Right(error.message);
    } catch (_) {
      return const Right(AuthLocale.getUserFailed);
    }
  }

  @override
  Future<Either<bool, String>> signOut() {
    return _guard(_auth.signOut, AuthLocale.signOutFailed);
  }

  Future<Either<bool, String>> _guard(
    Future<void> Function() action,
    String fallback,
  ) async {
    try {
      await action();
      return const Left(true);
    } on AppException catch (error) {
      return Right(error.message);
    } catch (_) {
      return Right(fallback);
    }
  }
}
