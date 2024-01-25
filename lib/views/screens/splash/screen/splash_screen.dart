import 'package:chat_app_24/utils/colors.dart';
import 'package:chat_app_24/views/screens/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              appSecondaryWhiteColor,
              appPrimaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset('assets/icon/logo.png'),
        ),
      ),
    );
  }
}
