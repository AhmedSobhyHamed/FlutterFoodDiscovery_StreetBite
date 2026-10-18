import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/widgets/login/login_form.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/widgets/login/login_form_header.dart';

class LoginPart extends StatelessWidget {
  const LoginPart({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final maxSize = ((height - 375) / height).clamp(0.60, 0.65);
    final minSize = 0.22.clamp(0.20, maxSize);
    final initialSize = 0.68.clamp(minSize, maxSize);

    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      minChildSize: minSize,
      maxChildSize: maxSize,
      snap: true,
      builder: (context, scrollController) {
        return ColoredBox(
          color: AppColors.green,
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
  } // build
} // LoginPart
