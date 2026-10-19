import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/usecases/login_withemail_password_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/login_status.dart';

class LoginCubit extends Cubit<loginStatus> {
  LoginCubit(this._loginWithEmailPasswordUsecase) : super(const loginStatusIdle());

  final LoginWithEmailPasswordUsecase _loginWithEmailPasswordUsecase;

  Future<void> login(String email, String password) async {
    emit(const loginStatusLoading());
    final result = await _loginWithEmailPasswordUsecase.call(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (_) => emit(const loginStatusSuccess()),
      (error) => emit(loginStatusError(message: error.message)),
    );
  }
}
