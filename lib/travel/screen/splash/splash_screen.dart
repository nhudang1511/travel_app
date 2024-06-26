import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nhu_nguyen/travel/on_boarding_page.dart';
import 'package:flutter_nhu_nguyen/travel/screen/main_screen.dart';

import '../../../config/image_helper.dart';
import '../../../config/shared_preferences.dart';
import '../screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  static Route route(){
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SplashScreen(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1000), () {
      if (SharedService.getIsFirstTime() == true) {
        Navigator.pushNamed(context, OnBoardingPage.routeName);
      } else if (SharedService.getUserId() == null) {
        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, MainScreen.routeName, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ImageHelper.loadFromAsset(
            'assets/logo/splashscreen.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }
}
