import 'package:flutterfooddiscovery_streetbite/features/auth/domain/entities/user_entite.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/entities/profile_entite.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.image,
    required super.emailVerified,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      emailVerified: false,
    );
  }
}

class ProfileModelBuilder {
  UserEntity? _user;
  String? _name;
  String? _email;
  String _image = '';
  bool _emailVerified = false;

  ProfileModelBuilder account({
    required UserEntity user,
    ProfileModel? stored,
    required bool emailVerified,
  }) {
    _user = user;
    _name = stored == null || stored.name.isEmpty ? user.name : stored.name;
    _email = stored == null || stored.email.isEmpty ? user.email : stored.email;
    _image = stored?.image ?? '';
    _emailVerified = emailVerified;
    return this;
  }

  ProfileModel build() {
    final user = _user;
    return ProfileModel(
      id: user?.id ?? '',
      name: _name ?? user?.name ?? '',
      email: _email ?? user?.email ?? '',
      image: _image,
      emailVerified: _emailVerified,
    );
  }
}
