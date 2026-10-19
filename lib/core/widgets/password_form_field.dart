import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/l10n/app_locale.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/core/widgets/app_field_decoration.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    super.key,
    required this.controller,
    required this.validator,
    this.hint,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hint;
  final TextInputAction textInputAction;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: AppColors.black, fontSize: 16),
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      decoration: appFieldDecoration(
        widget.hint ?? AppLocale.passwordHint.getString(context),
      ).copyWith(
        suffixIcon: IconButton(
          onPressed: () => setState(() {_obscureText = !_obscureText;}),
          icon: Icon(
            _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.grayDark,
          ),
        ),
      ),
    );
  }
}
