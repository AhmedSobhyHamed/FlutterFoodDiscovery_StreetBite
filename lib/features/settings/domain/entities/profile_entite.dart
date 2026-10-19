import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.emailVerified,
  });

  final String id;
  final String name;
  final String email;
  final String image;
  final bool emailVerified;

  @override
  List<Object?> get props => [id, name, email, image, emailVerified];
}
