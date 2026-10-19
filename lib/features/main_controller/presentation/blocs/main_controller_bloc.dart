import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/blocs/bloc_events.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/blocs/block_states.dart';

class MainControllerBloc
    extends Bloc<MainControllerEvent, MainControllerState> {
  MainControllerBloc() : super(const MainControllerInitial()) {
    on<MainControllerSplashFinished>(_onSplashFinished);
    on<MainControllerAuthenticated>(_onAuthenticated);
    on<MainControllerUnauthenticated>(_onUnauthenticated);
  }

  void _onSplashFinished(
    MainControllerSplashFinished event,
    Emitter<MainControllerState> emit,
  ) {
    emit(const MainControllerLogin());
  }

  void _onAuthenticated(
    MainControllerAuthenticated event,
    Emitter<MainControllerState> emit,
  ) {
    emit(const MainControllerHome());
  }

  void _onUnauthenticated(
    MainControllerUnauthenticated event,
    Emitter<MainControllerState> emit,
  ) {
    emit(const MainControllerLogin());
  }
}
