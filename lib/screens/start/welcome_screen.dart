import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/screens/auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: height * .05),
          Container(
            width: width,
            height: height * .2,
            margin: const EdgeInsets.all(20),
            child: const Text(
              "Find your Next \nBest Friend",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: width,
            height: height * .10,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "We will help you to choose your\nlovely pet. adopt a pet",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[500],
              ),
            ),
          ),
          Image.asset(
            "assets/images/welcome_image.jpg",
            height: height * .5,
          ),
          Container(
            height: (height * .12) - 40,
            margin: EdgeInsets.only(top: height * .01),
            width: width * .8,
            child: MaterialButton(
              onPressed: () {
                NavigationHelper.goToAndOff(context, LoginScreen());
              },
              color: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/footprint.svg",
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
