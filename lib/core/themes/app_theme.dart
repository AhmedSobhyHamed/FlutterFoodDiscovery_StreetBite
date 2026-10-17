import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/data_source_interface.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightOnPrimary,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        outline: AppColors.lightOutline,
        error: AppColors.lightError,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        secondary: AppColors.darkSecondary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        outline: AppColors.darkOutline,
        error: AppColors.darkError,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
      ),
    );
  }

  static Future<ThemeData> getcurrentTheme(
    DataSourceInterface dataSource,
  ) async {
    final theme = await dataSource.getEntity('theme', 'current');
    return theme.fold((saved) {
      if (saved['light'] == true) {
        return light;
      }
      return dark;
    }, (error) => dark);
  }

  static Future<void> setCurrentTheme(
    ThemeData theme,
    DataSourceInterface dataSource,
  ) async {
    final currentTheme = await dataSource.getEntity('theme', 'current');
    final payload = <String, dynamic>{
      'light': theme.brightness == Brightness.light,
      'dark': theme.brightness == Brightness.dark,
    };
    await currentTheme.fold(
      (saved) => dataSource.put('theme', 'current', payload),
      (error) => dataSource.post('theme', {
        'id': 'current',
        ...payload,
      }),
    );
  }
}
