import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/l10n/app_locale.dart';
import 'package:flutterfooddiscovery_streetbite/core/widgets/app_field_decoration.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({
    super.key,
    required this.controller,
    required this.validator,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: appFieldDecoration(AppLocale.emailHint.getString(context)),
    );
  }
}
