import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/widgets/signup/signup_form.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/presentation/widgets/signup/signup_form_header.dart';

class SignupPart extends StatelessWidget {
  const SignupPart({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final maxSize = ((height - 375) / height).clamp(0.73, 0.80);
    final minSize = 0.18.clamp(0.18, maxSize);
    final initialSize = 0.78.clamp(minSize, maxSize);

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
              SignupFormHeader(),
              SizedBox(height: 28),
              SignupForm(),
            ], // children
          ), // ListView
        ); // ColoredBox
      }, // builder
    ); // DraggableScrollableSheet
  }
} // SignupPart
