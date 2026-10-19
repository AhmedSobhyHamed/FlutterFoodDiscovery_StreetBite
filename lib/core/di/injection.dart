import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/data_source_interface.dart';
import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/local_data_source.dart';
import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/remote_data_source.dart';
import 'package:flutterfooddiscovery_streetbite/core/services/fingerprint_service.dart';
import 'package:flutterfooddiscovery_streetbite/core/services/fingerprint_via_local_auth.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_theme.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/di/injection.dart' as settings_di;
import 'package:flutterfooddiscovery_streetbite/features/auth/di/injection.dart' as auth_di;
import 'package:flutterfooddiscovery_streetbite/features/cart/di/injection.dart' as cart_di;
import 'package:flutterfooddiscovery_streetbite/features/fav/di/injection.dart' as fav_di;
import 'package:flutterfooddiscovery_streetbite/features/meals/di/injection.dart' as meals_di;
import 'package:flutterfooddiscovery_streetbite/features/order/di/injection.dart' as order_di;
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {

  await _setupDataSource();
  await _setupTheme();
  getIt.registerSingleton<FingerprintService>(FingerprintViaLocalAuth());
  auth_di.setupAuthDependencies();
  await meals_di.setupMealsDependencies();
  await cart_di.setupCartDependencies();
  order_di.setupOrderDependencies();
  await fav_di.setupFavDependencies();
  settings_di.setupSettingsDependencies();
}

// ===============================
// data sources
// ===============================
const String localDataSourceName = 'local';
const String remoteDataSourceName = 'remote';

DataSourceInterface get localDataSource =>
    getIt<DataSourceInterface>(instanceName: localDataSourceName);

DataSourceInterface get remoteDataSource =>
    getIt<DataSourceInterface>(instanceName: remoteDataSourceName);

Future<void> _setupDataSource() async {
  final preferences = await SharedPreferences.getInstance();
  final local = LocalDataSource(preferences);
  final remote = RemoteDataSource(Dio());

  getIt.registerSingleton<DataSourceInterface>(
    local,
    instanceName: localDataSourceName,
  );
  getIt.registerSingleton<DataSourceInterface>(
    remote,
    instanceName: remoteDataSourceName,
  );
}

// ===============================
// themes
// ===============================
Future<void> _setupTheme() async {
  final theme = await AppTheme.getcurrentTheme(localDataSource);
  getIt.registerSingleton<ValueNotifier<ThemeData>>(ValueNotifier(theme));
}
