import 'package:flutterfooddiscovery_streetbite/features/auth/data/datasources/auth_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/data/datasources/auth_via_firebase.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/data/models/user_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/data/repositories/auth_repository.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/usecases/login_withemail_password_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/usecases/signup_minimal_info_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/login_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/signout_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/signup_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupAuthDependencies() {
  getIt.registerSingleton<AuthWithEmailAndPasswordInterface<UserModel>>(
    AuthViaFirebase(),
  );
  getIt.registerSingleton<AuthRepositoryInterface>(
    AuthRepository(
      auth: getIt<AuthWithEmailAndPasswordInterface<UserModel>>(),
    ),
  );

  getIt.registerFactory<LoginWithEmailPasswordUsecase>(
    () => LoginWithEmailPasswordUsecase(getIt<AuthRepositoryInterface>()),
  );
  getIt.registerFactory<SignupMinimalInfoUsecase>(
    () => SignupMinimalInfoUsecase(getIt<AuthRepositoryInterface>()),
  );
  getIt.registerFactory<SignOutUsecase>(
    () => SignOutUsecase(getIt<AuthRepositoryInterface>()),
  );

  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<LoginWithEmailPasswordUsecase>()),
  );
  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(getIt<SignupMinimalInfoUsecase>()),
  );
  getIt.registerFactory<SignOutCubit>(
    () => SignOutCubit(getIt<SignOutUsecase>()),
  );
}
