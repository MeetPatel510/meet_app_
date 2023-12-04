import 'dart:async';

import 'package:meet_app/screens/auth/login_page.dart';
import 'package:meet_app/screens/landing/screens/landing_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

class SplashLoginPage extends StatefulWidget {
  const SplashLoginPage({super.key});

  @override
  State<SplashLoginPage> createState() => _SplashLoginPageState();
}

class _SplashLoginPageState extends State<SplashLoginPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset("assets/settingPhoto/splah.png"),

      nextScreen: LandingScreen(),
      duration: 4,
      splashIconSize: 70,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
