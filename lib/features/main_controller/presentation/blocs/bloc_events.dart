import 'package:equatable/equatable.dart';

abstract class MainControllerEvent extends Equatable {
  const MainControllerEvent();

  @override
  List<Object?> get props => [];
}

class MainControllerSplashFinished extends MainControllerEvent {
  const MainControllerSplashFinished();
}
