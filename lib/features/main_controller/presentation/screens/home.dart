import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/cart/presentation/screens/cart_page.dart';
import 'package:flutterfooddiscovery_streetbite/features/fav/presentation/screens/fav_page.dart';
import 'package:flutterfooddiscovery_streetbite/features/main_controller/l10n/main_controller_locale.dart';
import 'package:flutterfooddiscovery_streetbite/features/meals/presentation/screens/home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: IndexedStack(
        index: _index,
        children: const [
          HomePage(),
          FavPage(),
          CartPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.greenLight,
        onDestinationSelected: (index) => setState(() => _index = index),
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
        ],
      ),
    );
  }
}
