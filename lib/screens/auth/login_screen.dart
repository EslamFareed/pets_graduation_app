import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/screens/auth/create_account_screen.dart';

import '../main/main_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool isLoading = false;

  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/image1.jpg",
              fit: BoxFit.cover,
              height: MediaQuery.sizeOf(context).height * .5,
            ),
            Container(
              alignment: Alignment.center,
              margin:
                  EdgeInsets.only(top: MediaQuery.sizeOf(context).height * .01),
              height: MediaQuery.sizeOf(context).height * .1,
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.sizeOf(context).height * .05,
              child: Text(
                "Sign in to continue",
                style: TextStyle(fontSize: 15, color: Colors.grey[400]),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Email",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Password",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                controller: passwordController,
                obscureText: hidden,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidden = !hidden;
                      });
                    },
                    icon:
                        Icon(hidden ? Icons.visibility_off : Icons.visibility),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.sizeOf(context).height * .02),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : MaterialButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          var user = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          if (user.user != null) {
                            await SharedHelper.editFirstTime();
                            await SharedHelper.editLogin();
                            SharedHelper.setUserId(user.user!.uid)
                                .then((value) {
                              NavigationHelper.goToAndOffAll(
                                  context, MainLayout());
                            });
                          }
                        } catch (e) {
                          print(e.toString());
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      color: Colors.deepPurple,
                      textColor: Colors.white,
                      minWidth: MediaQuery.sizeOf(context).width * .9,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 50,
                      child: const Text("Log in"),
                    ),
            ),
            GestureDetector(
              onTap: () {
                NavigationHelper.goTo(context, CreateAccountScreen());
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Text("Sign Up"),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
