import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/current_user_status.dart';

class CurrentUserCubit extends Cubit<currentUserStatus> {
  CurrentUserCubit(this._getCurrentUser) : super(const currentUserStatusIdle());

  final GetCurrentUserUsecase _getCurrentUser;

  Future<void> load() async {
    emit(const currentUserStatusLoading());
    final result = await _getCurrentUser.call(const GetCurrentUserParams());
    if (isClosed) return;
    result.fold(
      (_) => emit(const currentUserStatusFound()),
      (_) => emit(const currentUserStatusMissing()),
    );
  }
}
