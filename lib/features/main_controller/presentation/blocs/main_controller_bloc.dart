import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/blocs/bloc_events.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/blocs/block_states.dart';

class MainControllerBloc
    extends Bloc<MainControllerEvent, MainControllerState> {
  MainControllerBloc() : super(const MainControllerInitial()) {
    on<MainControllerSplashFinished>(_onSplashFinished);
  }

  void _onSplashFinished(
    MainControllerSplashFinished event,
    Emitter<MainControllerState> emit,
  ) {
    emit(const MainControllerLogin());
  }
}
