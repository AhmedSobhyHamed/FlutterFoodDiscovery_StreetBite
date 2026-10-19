import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/auth_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/data/datasources/user_service.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/data/models/profile_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/entities/profile_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/repositories/profile_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/l10n/profile_locale.dart';

class ProfileRepository implements ProfileRepositoryInterface {
  ProfileRepository({required UserService users, required AuthRepositoryInterface auth})
    : _users = users,
      _auth = auth;

  final UserService _users;
  final AuthRepositoryInterface _auth;

  @override
  Future<Either<bool, String>> saveAccount({
    required String id,
    required String name,
    required String email,
  }) async {
    try {
      await _users.saveAccount(id: id, name: name, email: email);
      return const Left(true);
    } on AppException catch (error) {
      return Right(error.message);
    } catch (_) {
      return const Right(ProfileLocale.saveFailed);
    }
  }

  @override
  Future<Either<ProfileEntity, String>> getProfile() async {
    final current = await _auth.getCurrentUser();
    if (current.isRight()) {
      return Right(current.fold((_) => AuthLocale.userNotFound, (message) => message));
    }
    final user = current.fold((value) => value, (_) => null);
    if (user == null) return const Right(AuthLocale.userNotFound);
    try {
      final stored = await _users.read(user.id);
      final verified = await _users.emailVerified();
      return Left(
        ProfileModelBuilder()
            .account(
              user: user,
              stored: stored,
              emailVerified: verified,
            )
            .build(),
      );
    } on AppException catch (error) {
      return Right(error.message);
    } catch (_) {
      return const Right(ProfileLocale.loadFailed);
    }
  }

  @override
  Future<Either<ProfileEntity, String>> update({
    required String name,
    required String email,
    required String image,
  }) async {
    final current = await _auth.getCurrentUser();
    if (current.isRight()) {
      return Right(current.fold((_) => AuthLocale.userNotFound, (message) => message));
    }
    final user = current.fold((value) => value, (_) => null);
    if (user == null) return const Right(AuthLocale.userNotFound);
    try {
      await _users.update(id: user.id, name: name, email: email, image: image);
      final stored = await _users.read(user.id);
      final verified = await _users.emailVerified();
      return Left(
        ProfileModelBuilder()
            .account(
              user: user,
              stored: stored,
              emailVerified: verified,
            )
            .build(),
      );
    } on AppException catch (error) {
      return Right(error.message);
    } catch (_) {
      return const Right(ProfileLocale.saveFailed);
    }
  }

}
