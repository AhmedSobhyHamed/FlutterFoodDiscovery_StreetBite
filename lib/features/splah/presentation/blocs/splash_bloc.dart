import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/splah/presentation/blocs/splash_events.dart';
import 'package:flutterfooddiscovery_streetbite/features/splah/presentation/blocs/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitial()) {
    on<SplashFinishEvent>(_onFinish);
  }

  void _onFinish(SplashFinishEvent event, Emitter<SplashState> emit) {
    emit(const SplashFinished());
  }
}
