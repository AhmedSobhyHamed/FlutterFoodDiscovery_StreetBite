import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';

InputDecoration appFieldDecoration(String hint) {
  return InputDecoration(
    filled: true,
    fillColor: AppColors.white,
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.grayDark, fontSize: 16),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: _border(),
    enabledBorder: _border(),
    focusedBorder: _border(),
    errorBorder: _border(AppColors.lightError),
    focusedErrorBorder: _border(AppColors.lightError),
  );
}

OutlineInputBorder _border([Color color = Colors.transparent]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: color),
  );
}
