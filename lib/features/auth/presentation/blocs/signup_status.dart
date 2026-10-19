import 'package:equatable/equatable.dart';

abstract class signupStatus extends Equatable {
  const signupStatus();

  @override
  List<Object?> get props => [];
}

class signupStatusIdle extends signupStatus {
  const signupStatusIdle();
}

class signupStatusLoading extends signupStatus {
  const signupStatusLoading();
}

class signupStatusSuccess extends signupStatus {
  const signupStatusSuccess();
}

class signupStatusError extends signupStatus {
  const signupStatusError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
