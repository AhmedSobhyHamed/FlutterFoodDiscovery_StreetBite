import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/screens/login_page.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/blocs/bloc_events.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/blocs/block_states.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/blocs/main_controller_bloc.dart';
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
      ],
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashFinished) {
            context.read<MainControllerBloc>().add(
              const MainControllerSplashFinished(),
            );
          }
        },
        child: BlocBuilder<MainControllerBloc, MainControllerState>(
          builder: (context, state) {
            if (state is MainControllerLogin) {
              return const LoginPage();
            }
            return const SplashScreen();
          },
        ), // BlocBuilder
      ), // BlocListener
    ); // MultiBlocProvider
  } // build
} // MainScreen
