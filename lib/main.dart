import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/features/splah/presentation/screens/splash.dart';
import 'package:flutterfooddiscovery_streetbite/core/data_source.dart/local_data_source.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      theme: getTheme(),
    );
  }

  Future<ThemeData> getTheme() async {
    return await AppTheme.getcurrentTheme(LocalDataSource.instance);
  }
}
// anime
// bloc
// control from outside