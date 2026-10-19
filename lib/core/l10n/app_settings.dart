import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/data_source_interface.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_theme.dart';

class AppSettings {
  static void setLanguage(String code) {
    FlutterLocalization.instance.translate(code);
  }

  static Future<void> setTheme(
    ThemeData theme,
    DataSourceInterface dataSource,
    ValueNotifier<ThemeData> current,
  ) async {
    await AppTheme.setCurrentTheme(theme, dataSource);
    current.value = theme;
  }
}
