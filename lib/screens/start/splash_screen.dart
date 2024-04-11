import 'package:flutter/material.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/screens/auth/login_screen.dart';
import 'package:pets_graduation_app/screens/main/main_layout.dart';
import 'package:pets_graduation_app/screens/start/welcome_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      NavigationHelper.goToAndOff(
          context,
          SharedHelper.checkFirstTime()
              ? const WelcomeScreen()
              : SharedHelper.checkLogin()
                  ? MainLayout()
                  : LoginScreen());
    });

    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: height * .25),
              child: Image.asset(
                "assets/images/logo.jpg",
                width: width * .7,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: height * .25),
              child: const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
