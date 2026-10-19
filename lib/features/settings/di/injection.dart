import 'package:flutterfooddiscovery_streetbite/core/services/fingerprint_service.dart';
import 'package:flutterfooddiscovery_streetbite/core/services/image_service.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/data/datasources/image_via_gallery.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/data/datasources/user_service.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/data/datasources/user_via_firestore.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/data/repositories/profile_repository.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/repositories/profile_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/usecases/get_profile_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/usecases/unlock_profile_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/usecases/update_profile_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/presentation/blocs/profile_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupSettingsDependencies() {
  getIt.registerSingleton<UserService>(UserViaFirestore());
  getIt.registerSingleton<ImageService>(ImageViaGallery());
  getIt.registerSingleton<ProfileRepositoryInterface>(
    ProfileRepository(
      users: getIt<UserService>(),
      auth: getIt<AuthRepositoryInterface>(),
    ),
  );

  getIt.registerFactory<GetProfileUsecase>(
    () => GetProfileUsecase(getIt<ProfileRepositoryInterface>()),
  );
  getIt.registerFactory<UpdateProfileUsecase>(
    () => UpdateProfileUsecase(getIt<ProfileRepositoryInterface>()),
  );
  getIt.registerFactory<UnlockProfileUsecase>(
    () => UnlockProfileUsecase(getIt<FingerprintService>()),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getIt<GetProfileUsecase>(),
      getIt<UpdateProfileUsecase>(),
      getIt<VerifyEmailUsecase>(),
      getIt<ImageService>(),
    ),
  );
}
