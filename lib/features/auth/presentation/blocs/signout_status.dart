import 'package:equatable/equatable.dart';

abstract class signoutStatus extends Equatable {
  const signoutStatus();

  @override
  List<Object?> get props => [];
}

class signoutStatusIdle extends signoutStatus {
  const signoutStatusIdle();
}

class signoutStatusLoading extends signoutStatus {
  const signoutStatusLoading();
}

class signoutStatusSuccess extends signoutStatus {
  const signoutStatusSuccess();
}

class signoutStatusError extends signoutStatus {
  const signoutStatusError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
