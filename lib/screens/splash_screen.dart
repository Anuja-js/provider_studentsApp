// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:providerregisterapp/customs/constants.dart';
import 'package:providerregisterapp/customs/text_custom.dart';
import '../providers/splash_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).init();
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.jpeg",
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/splash.png",
                  width: 150.w,
                  height: 150.h,
                ),
             sh20,
                 TextCustom(text:
                  "Students Register",
                 color: black,textSize: 22.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
