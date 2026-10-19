import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/di/injection.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/presentation/screens/cart_page.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/presentation/screens/fav_page.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/l10n/main_controller_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/screens/home_page.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/domain/usecases/unlock_profile_usecase.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/presentation/screens/settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _index = 0;
  var _settingsUnlocked = false;

  Future<void> _select(int index) async {
    // fingerprint before the settings tab, and only for a signed-in user
    if (index == 3 && _index != 3) {
      final result = await getIt<UnlockProfileUsecase>().call(
        UnlockProfileParams(reason: MainControllerLocale.settingsFingerprint.getString(context)),
      );
      if (!mounted) return;
      final allowed = result.fold((value) => value, (_) => false);
      if (!allowed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(MainControllerLocale.settingsLocked.getString(context)),
          ),
        );
        return;
      }
      setState(() {
        _settingsUnlocked = true;
        _index = index;
      });
      return;
    }
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: IndexedStack(
        index: _index,
        children: [
          const HomePage(),
          const FavPage(),
          const CartPage(),
          _settingsUnlocked ? const SettingsPage() : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.greenLight,
        onDestinationSelected: _select,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined, color: AppColors.grayDark),
            selectedIcon: const Icon(Icons.home, color: AppColors.green),
            label: MainControllerLocale.home.getString(context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outlined, color: AppColors.grayDark),
            selectedIcon: const Icon(Icons.favorite, color: AppColors.green),
            label: MainControllerLocale.favorites.getString(context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.grayDark),
            selectedIcon: const Icon(Icons.shopping_cart, color: AppColors.green),
            label: MainControllerLocale.cart.getString(context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined, color: AppColors.grayDark),
            selectedIcon: const Icon(Icons.settings, color: AppColors.green),
            label: MainControllerLocale.settings.getString(context),
          ),
        ],
      ),
    );
  }
}
