import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/core/services/image_service.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/usecases/get_profile_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/usecases/update_profile_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/l10n/profile_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/presentation/blocs/profile_status.dart';

class ProfileCubit extends Cubit<profileStatus> {
  ProfileCubit(this._getProfile, this._updateProfile, this._verifyEmail, this._images)
    : super(const profileStatusIdle());

  final GetProfileUsecase _getProfile;
  final UpdateProfileUsecase _updateProfile;
  final VerifyEmailUsecase _verifyEmail;
  final ImageService _images;

  Future<void> load() async {
    emit(const profileStatusLoading());
    final result = await _getProfile.call(const GetProfileParams());
    if (isClosed) return;
    result.fold(
      (profile) => emit(profileStatusLoaded(profile: profile)),
      (error) => emit(profileStatusError(message: error.message)),
    );
  }

  Future<void> save({required String name, required String email}) async {
    final current = state;
    if (current is! profileStatusLoaded || current.saving) return;
    emit(profileStatusLoaded(profile: current.profile, saving: true));
    final result = await _updateProfile.call(
      UpdateProfileParams(name: name, email: email, image: current.profile.image),
    );
    if (isClosed) return;
    result.fold(
      (profile) => emit(profileStatusLoaded(profile: profile)),
      (error) => emit(profileStatusLoaded(profile: current.profile, message: error.message)),
    );
  }

  Future<void> pickImage({required String name, required String email}) async {
    final current = state;
    if (current is! profileStatusLoaded || current.saving) return;
    final path = await _images.pickOneFromGallery();
    if (path == null || isClosed) return;
    emit(profileStatusLoaded(profile: current.profile, saving: true));
    final result = await _updateProfile.call(
      UpdateProfileParams(name: name, email: email, image: path),
    );
    if (isClosed) return;
    result.fold(
      (profile) => emit(profileStatusLoaded(profile: profile)),
      (error) => emit(profileStatusLoaded(profile: current.profile, message: error.message)),
    );
  }

  Future<void> verify() async {
    final current = state;
    if (current is! profileStatusLoaded || current.profile.emailVerified || current.saving) return;
    emit(profileStatusLoaded(profile: current.profile, saving: true));
    final result = await _verifyEmail.call(const VerifyEmailParams());
    if (isClosed) return;
    result.fold(
      (_) => emit(profileStatusLoaded(profile: current.profile, message: ProfileLocale.verifySent)),
      (error) => emit(profileStatusLoaded(profile: current.profile, message: error.message)),
    );
  }
}
