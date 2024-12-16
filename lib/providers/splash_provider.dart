import 'package:flutter/material.dart';
import 'package:providerregisterapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class SplashProvider extends ChangeNotifier {
  Future<void> init() async {
    await checkUserLoggedIn();
  }

  Future<void> checkUserLoggedIn() async {

    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
      final isLoggedin = await prefs.getBool('userLoggedIn');
      print(isLoggedin);
    await Future.delayed(const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLoggedin==false|| isLoggedin==null) {Navigator.of(navigatorKey.currentContext!).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );

      } else {
        Navigator.of(navigatorKey.currentContext!).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
    notifyListeners();
  }


}
