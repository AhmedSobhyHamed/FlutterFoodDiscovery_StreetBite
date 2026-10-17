// Splash screen

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfooddiscovery_streetbite/core/general/appconfig.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), 
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  } // initState

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  } // dispose

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/images/splash.svg',
                width: 100,
                height: 100,
                semanticsLabel: AppConfig.appName,
              ),
            ), //Center
            SizedBox(height: 20),
            Text(
              AppConfig.appName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ), //Text
          ],
        ), //Column
      ), //FadeTransition
    ); //Scaffold
  } // build
}