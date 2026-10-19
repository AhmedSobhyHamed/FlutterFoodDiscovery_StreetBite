import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/signout_status.dart';

class SignOutCubit extends Cubit<signoutStatus> {
  SignOutCubit(this._signOutUsecase) : super(const signoutStatusIdle());

  final SignOutUsecase _signOutUsecase;

  Future<void> signOut() async {
    emit(const signoutStatusLoading());
    final result = await _signOutUsecase.call(const SignOutParams());
    result.fold(
      (_) => emit(const signoutStatusSuccess()),
      (error) => emit(signoutStatusError(message: error.message)),
    );
  }
}
