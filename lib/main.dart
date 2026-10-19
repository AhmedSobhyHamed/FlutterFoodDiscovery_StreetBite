import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/core/di/injection.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/presentation/blocs/cart_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/presentation/blocs/fav_cubit.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/presentation/screens/main.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  await Firebase.initializeApp();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    _localization.init(
      initLanguageCode: 'en',
      source: LocalizationSource.jsonAsset,
      jsonLocales: const [
        JsonLocale('en', 'assets/l10n/app_en.json'),
        JsonLocale('ar', 'assets/l10n/app_ar.json'),
      ],
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
  } // initState

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  } // _onTranslatedLanguage

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CartCubit>()..load()),
        BlocProvider(create: (_) => getIt<FavCubit>()..load()),
      ],
      child: ListenableBuilder(
        listenable: getIt<ValueNotifier<ThemeData>>(),
        builder: (context, _) {
          return MaterialApp(
            locale: _localization.currentLocale,
            supportedLocales: _localization.supportedLocales,
            localizationsDelegates: _localization.localizationsDelegates,
            home: const MainScreen(),
            theme: getIt<ValueNotifier<ThemeData>>().value,
          );
        },
      ),
    );
  } // build
} // _MyAppState
