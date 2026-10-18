// Splash screen

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfooddiscovery_streetbite/core/general/appconfig.dart';
import 'package:flutterfooddiscovery_streetbite/core/themes/app_colors.dart';
import 'package:flutterfooddiscovery_streetbite/features/splah/presentation/blocs/splash_bloc.dart';
import 'package:flutterfooddiscovery_streetbite/features/splah/presentation/blocs/splash_events.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  var _finished = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.addStatusListener(_onAnimationStatus);
    _animationController.forward();
  } // initState

  @override
  void dispose() {
    _animationController.removeStatusListener(_onAnimationStatus);
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
            ),
            const SizedBox(height: 20),
            Text(
              AppConfig.appName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.yellow),
            ), // Text
          ], // children
        ), // Column
      ), // FadeTransition
    ); // Scaffold
  } // build

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController.reverse();
      return;
    }
    if (status != AnimationStatus.dismissed || _finished || !mounted) {
      return;
    }
    _finished = true;
    context.read<SplashBloc>().add(const SplashFinishEvent());
  } // _onAnimationStatus
} // _SplashScreenState
