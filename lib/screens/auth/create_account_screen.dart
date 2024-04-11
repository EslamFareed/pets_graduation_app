import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/local/shared_helper.dart';
import '../../core/utils/navigation_helper.dart';
import '../main/main_layout.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  XFile? image;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.sizeOf(context).height * .065,
        title: const Text("Create New Account"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * .9,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/image1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * .7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          setState(() {});
                        },
                        child: image == null
                            ? const CircleAvatar(
                                backgroundImage: AssetImage(
                                    "assets/images/placeholder.webp"),
                                maxRadius: 60,
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(File(image!.path)),
                                maxRadius: 60,
                              ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Name",
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
                          controller: nameController,
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
                          "Phone",
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
                          controller: phoneController,
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
                          "Confirm Password",
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
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.sizeOf(context).height * .02),
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : MaterialButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    final storageRef =
                                        FirebaseStorage.instance.ref();
                                    final mountainImagesRef = storageRef
                                        .child("images/${image!.name}");
                                    String imageString = "";
                                    try {
                                      var response = await mountainImagesRef
                                          .putFile(File(image!.path));

                                      imageString =
                                          await response.ref.getDownloadURL();
                                    } catch (e) {
                                      print(e.toString());
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                    var user = await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );

                                    if (user.user != null) {
                                      await SharedHelper.editFirstTime();
                                      await SharedHelper.editLogin();
                                      await SharedHelper.setUserId(
                                          user.user!.uid);

                                      FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(user.user!.uid)
                                          .set({
                                        "email": emailController.text,
                                        "name": nameController.text,
                                        "password": nameController.text,
                                        "phone": phoneController.text,
                                        "picture": imageString,
                                      }).then((value) {
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
                                child: const Text("Sign up"),
                              ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
