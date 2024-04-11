import 'package:flutter/material.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/screens/main/main_layout.dart';

class MakeOrderScreen extends StatelessWidget {
  const MakeOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      NavigationHelper.goToAndOff(
        context,
        const MainLayout(),
      );
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 200,
              color: Colors.green,
            ),
            Text(
              "Order Created Successfully",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
