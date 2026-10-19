import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/entities/user_entite.dart';

abstract interface class AuthRepositoryInterface {
  Future<Either<bool, String>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<bool, String>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<bool, String>> forgotPassword({required String email});

  Future<Either<bool, String>> verifyEmail();

  Future<Either<UserEntity, String>> getCurrentUser();

  Future<Either<bool, String>> signOut();
}
