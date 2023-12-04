import 'dart:async';

import 'package:meet_app/whatsapp.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

class SplashPageHome extends StatefulWidget {
  const SplashPageHome({super.key});

  @override
  State<SplashPageHome> createState() => _SplashPageHomeState();
}

class _SplashPageHomeState extends State<SplashPageHome> {
  @override
  Widget build(BuildContext context) {

    return AnimatedSplashScreen(
      splash: Image.asset("assets/settingPhoto/splah.png"),
      nextScreen: WhatsApp(),
      duration: 5,
      splashIconSize: 70,
      splashTransition: SplashTransition.fadeTransition,

    );

  }
}
