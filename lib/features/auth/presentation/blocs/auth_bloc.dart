import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_events.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthStateUnauthenticated()) {
    on<becomeAthenticatedEvent>(_onBecomeAthenticatedEvent);
    on<becomeUnauthenticatedEvent>(_onBecomeUnauthenticatedEvent);
  }

  void _onBecomeAthenticatedEvent(
    becomeAthenticatedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthStateAuthenticated());
  }

  void _onBecomeUnauthenticatedEvent(
    becomeUnauthenticatedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthStateUnauthenticated());
  }
}
