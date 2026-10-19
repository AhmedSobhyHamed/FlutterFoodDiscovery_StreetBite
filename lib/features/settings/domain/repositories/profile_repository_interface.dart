import 'package:dartz/dartz.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/entities/profile_entite.dart';

abstract interface class ProfileRepositoryInterface {
  Future<Either<bool, String>> saveAccount({
    required String id,
    required String name,
    required String email,
  });

  Future<Either<ProfileEntity, String>> getProfile();

  Future<Either<ProfileEntity, String>> update({
    required String name,
    required String email,
    required String image,
  });
}
