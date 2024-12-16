// main.dart
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerregisterapp/providers/home_provider.dart';
import 'package:providerregisterapp/providers/login_provider.dart';
import 'package:providerregisterapp/providers/splash_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:providerregisterapp/screens/splash_screen.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            title: "ProviderRegister",navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primaryColor: Colors.deepPurple),
            home: const SplashScreen(),
          );
        });
  }
}
