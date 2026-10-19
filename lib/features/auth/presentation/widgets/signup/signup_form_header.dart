import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/signup_locale.dart';

class SignupFormHeader extends StatelessWidget {
  const SignupFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          SignupLocale.signupTitle.getString(context),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          SignupLocale.signupDescription.getString(context),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.white,
            height: 1.4,
          ),
        ),
      ], // children
    ); // Column
  } // build
} // SignupFormHeader
