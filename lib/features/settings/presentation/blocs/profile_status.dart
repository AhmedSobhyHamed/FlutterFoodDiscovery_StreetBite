import 'package:equatable/equatable.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/entities/profile_entite.dart';

abstract class profileStatus extends Equatable {
  const profileStatus();

  @override
  List<Object?> get props => [];
}

class profileStatusIdle extends profileStatus {
  const profileStatusIdle();
}

class profileStatusLoading extends profileStatus {
  const profileStatusLoading();
}

class profileStatusError extends profileStatus {
  const profileStatusError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class profileStatusLoaded extends profileStatus {
  const profileStatusLoaded({required this.profile, this.message, this.saving = false});

  final ProfileEntity profile;
  final String? message;
  final bool saving;

  @override
  List<Object?> get props => [profile, message, saving];
}
