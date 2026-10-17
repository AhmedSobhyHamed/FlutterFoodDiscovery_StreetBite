import 'package:flutter/material.dart';
import 'package:flutterfooddiscovery_streetbite/core/di/injection.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/screens/main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      theme: getIt<ThemeData>(),
    );
  }
}
// anime
// bloc
// control from outside
