import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/login_locale.dart';

class LoginValidator {
  static String? validateEmail(String? value, BuildContext context) {
    // not empty have email format and have @ and . after @ and last word after . have at least 2 chars
    if (value == null || value.isEmpty) {
      return LoginLocale.emailRequired.getString(context);
    }
    if (!value.contains('@')) {
      return LoginLocale.emailInvalid.getString(context);
    }
    if (!value.substring(value.indexOf('@') + 1).contains('.')) {
      return LoginLocale.emailInvalid.getString(context);
    }
    if (value.substring(value.lastIndexOf('.') + 1).length < 2) {
      return LoginLocale.emailInvalid.getString(context);
    }
    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    // not empty have not less than 8 char and have chars and numbers
    if (value == null || value.isEmpty) {
      return LoginLocale.passwordRequired.getString(context);
    }
    if (value.length < 8) {
      return LoginLocale.passwordLength.getString(context);
    }
    if (!value.contains(RegExp(r'[a-z]')) || !value.contains(RegExp(r'[0-9]'))) {
      return LoginLocale.passwordCharsNumbers.getString(context);
    }
    return null;
  }
}