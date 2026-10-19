import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class becomeAthenticatedEvent extends AuthEvent {
  const becomeAthenticatedEvent();

  @override
  List<Object?> get props => [];
}

class becomeUnauthenticatedEvent extends AuthEvent {
  const becomeUnauthenticatedEvent();

  @override
  List<Object?> get props => [];
}