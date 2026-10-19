import 'package:equatable/equatable.dart';

abstract class currentUserStatus extends Equatable {
  const currentUserStatus();

  @override
  List<Object?> get props => [];
}

class currentUserStatusIdle extends currentUserStatus {
  const currentUserStatusIdle();
}

class currentUserStatusLoading extends currentUserStatus {
  const currentUserStatusLoading();
}

class currentUserStatusFound extends currentUserStatus {
  const currentUserStatusFound();
}

class currentUserStatusMissing extends currentUserStatus {
  const currentUserStatusMissing();
}
