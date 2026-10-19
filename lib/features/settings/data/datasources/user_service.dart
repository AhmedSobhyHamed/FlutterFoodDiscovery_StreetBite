import 'package:flutterfooddiscovery_streetbite/features/settings/data/models/profile_model.dart';

abstract interface class UserService {
  Future<ProfileModel?> read(String id);

  Future<void> saveAccount({
    required String id,
    required String name,
    required String email,
  });

  Future<void> update({
    required String id,
    required String name,
    required String email,
    required String image,
  });

  Future<bool> emailVerified();
}
