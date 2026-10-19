import 'package:equatable/equatable.dart';

abstract class MainControllerState extends Equatable {
  const MainControllerState();

  @override
  List<Object?> get props => [];
}

class MainControllerInitial extends MainControllerState {
  const MainControllerInitial();
}

class MainControllerLogin extends MainControllerState {
  const MainControllerLogin();
}

class MainControllerHome extends MainControllerState {
  const MainControllerHome();
}
