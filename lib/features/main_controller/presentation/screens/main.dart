import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/di/injection.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_events.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_states.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/current_user_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/current_user_status.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/screens/login_page.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/blocs/bloc_events.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/blocs/block_states.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/blocs/main_controller_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/screens/home.dart';
import 'package:flutterfooddiscovery_streetbite/features/splah/presentation/blocs/splash_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/splah/presentation/blocs/splash_state.dart';
import 'package:flutterfooddiscovery_streetbite/features/splah/presentation/screens/splash.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MainControllerBloc()),
        BlocProvider(create: (_) => SplashBloc()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => getIt<CurrentUserCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SplashBloc, SplashState>(
            listener: (context, state) {
              if (state is SplashFinished) {
                context.read<CurrentUserCubit>().load();
              }
            },
          ), // BlocListener
          BlocListener<CurrentUserCubit, currentUserStatus>(
            listener: (context, state) {
              if (state is currentUserStatusFound) {
                context.read<AuthBloc>().add(const becomeAthenticatedEvent());
                return;
              }
              if (state is currentUserStatusMissing) {
                context.read<MainControllerBloc>().add(
                  const MainControllerSplashFinished(),
                );
              }
            },
          ), // BlocListener
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              final controller = context.read<MainControllerBloc>();
              if (state is AuthStateAuthenticated) {
                controller.add(const MainControllerAuthenticated());
              } else if (state is AuthStateUnauthenticated) {
                controller.add(const MainControllerUnauthenticated());
              }
            },
          ), // BlocListener
        ], // listeners
        child: BlocBuilder<MainControllerBloc, MainControllerState>(
          builder: (context, state) {
            if (state is MainControllerHome) {
              return const HomeScreen();
            }
            if (state is MainControllerLogin) {
              return const LoginPage();
            }
            return const SplashScreen();
          }, // builder
        ), // BlocBuilder
      ), // MultiBlocListener
    ); // MultiBlocProvider
  } // build
} // MainScreen
