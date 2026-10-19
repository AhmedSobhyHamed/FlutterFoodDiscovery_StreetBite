import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/usecases/signup_minimal_info_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/signup_status.dart';

class SignupCubit extends Cubit<signupStatus> {
  SignupCubit(this._signupMinimalInfoUsecase) : super(const signupStatusIdle());

  final SignupMinimalInfoUsecase _signupMinimalInfoUsecase;

  Future<void> signup(String name, String email, String password) async {
    emit(const signupStatusLoading());
    final result = await _signupMinimalInfoUsecase.call(
      SignupParams(name: name, email: email, password: password),
    );
    result.fold(
      (_) => emit(const signupStatusSuccess()),
      (error) => emit(signupStatusError(message: error.message)),
    );
  }
}
