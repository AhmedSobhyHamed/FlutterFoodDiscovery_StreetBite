import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/widgets/login/login_form.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/widgets/login/login_form_header.dart';

class SignupPart extends StatelessWidget {
  const SignupPart({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.58,
      minChildSize: 0.46,
      maxChildSize: 0.72,
      snap: true,
      builder: (context, scrollController) {
        return ColoredBox(
          color: AppColors.white,
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            children: const [
              LoginFormHeader(),
              SizedBox(height: 28),
              LoginForm(),
            ], // children
          ), // ColoredBox
        ); // DraggableScrollableSheet
      }, // builder
    ); // DraggableScrollableSheet
  }
}