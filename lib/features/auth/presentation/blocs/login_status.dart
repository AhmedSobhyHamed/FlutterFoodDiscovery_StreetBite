import 'package:equatable/equatable.dart';

abstract class loginStatus extends Equatable {
  const loginStatus();

  @override
  List<Object?> get props => [];
}

class loginStatusIdle extends loginStatus {
  const loginStatusIdle();
}

class loginStatusLoading extends loginStatus {
  const loginStatusLoading();
}

class loginStatusSuccess extends loginStatus {
  const loginStatusSuccess();
}

class loginStatusError extends loginStatus {
  const loginStatusError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
