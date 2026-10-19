import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/domain/validators/login_validator.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/signup_locale.dart';

class SignupValidator extends LoginValidator {
  const SignupValidator();

  String? validateName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return SignupLocale.nameRequired.getString(context);
    }
    if (value.length < 3) {
      return SignupLocale.nameLength.getString(context);
    }
    if (!RegExp(r'^[A-Z][a-zA-Z\s]+$').hasMatch(value)) {
      return SignupLocale.nameInvalid.getString(context);
    }
    return null;
  }

  String? validateConfirmPassword(
    String? value,
    String password,
    BuildContext context,
  ) {
    if (value == null || value.isEmpty) {
      return SignupLocale.confirmPasswordRequired.getString(context);
    }
    if (value != password) {
      return SignupLocale.confirmPasswordNotMatch.getString(context);
    }
    return null;
  }
}
