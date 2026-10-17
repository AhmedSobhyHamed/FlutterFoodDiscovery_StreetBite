import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // Base Palette Colors from your design
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF00C874);
  static const Color greenLight = Color(0xFFE5F9F1);
  static const Color black = Color(0xFF1C1B1F);
  static const Color yellow = Color(0xFFFFA800);
  static const Color grayLight = Color(0xFFF7F7F7);
  static const Color grayDark = Color(0xFFA09CAB);
  static const Color grayMid = Color(0xFFDBDEE4);

  // --- Light Theme Mapping ---
  static const Color lightPrimary = green;
  static const Color lightOnPrimary = white;
  static const Color lightSecondary = greenLight;
  static const Color lightBackground = white;
  static const Color lightSurface = grayLight;
  static const Color lightOnSurface = black;
  static const Color lightOutline = grayMid;
  static const Color lightError = Color(0xFFBA1A1A); // Standard Material 3 Light Error

  // --- Dark Theme Mapping ---
  static const Color darkPrimary = green;
  static const Color darkOnPrimary = white;
  static const Color darkSecondary = greenLight;
  static const Color darkBackground = black;
  static const Color darkSurface = black; 
  static const Color darkOnSurface = white;
  static const Color darkOutline = grayDark;
  static const Color darkError = Color(0xFFFFB4AB); // Standard Material 3 Dark Error
}
