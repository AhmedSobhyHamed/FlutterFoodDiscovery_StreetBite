import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_show_status.dart';

class AuthShowCubit extends Cubit<AuthShowStatus> {
  AuthShowCubit() : super(AuthShowStatusLogin());

  void showLogin() {
    emit(AuthShowStatusLogin());
  }

  void showSignup() {
    emit(AuthShowStatusSignup());
  }
}