import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_show_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/blocs/auth_show_status.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/widgets/login/login_part.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/widgets/signup/signip_part.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthShowCubit(),
      child: BlocBuilder<AuthShowCubit, AuthShowStatus>(
        builder: (context, status) {
          return Scaffold(
            backgroundColor: const Color(0xFFDAE0E0),
            body: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.asset(
                    'assets/images/auth_bkg.png',
                    width: MediaQuery.sizeOf(context).width,
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                  status is AuthShowStatusSignup ? const SignupPart() : const LoginPart(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
