import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/core/utils/show_message.dart';
import 'package:pets_graduation_app/cubits/user/user_cubit.dart';

import '../../core/utils/navigation_helper.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  XFile? image;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    nameController.text = UserCubit.get(context).userData["name"];
    emailController.text = UserCubit.get(context).userData["email"];
    phoneController.text = UserCubit.get(context).userData["phone"];
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: ListView(
          children: [
            image == null
                ? CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                        UserCubit.get(context).userData["picture"]),
                  )
                : CircleAvatar(
                    radius: 70,
                    backgroundImage: FileImage(File(image!.path)),
                  ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: MaterialButton(
                onPressed: () async {
                  image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  setState(() {});
                },
                color: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textColor: Colors.white,
                child: const Text("Change Profile Picture"),
              ),
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
              ),
            ),
            const SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : MaterialButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (image == null &&
                            UserCubit.get(context).userData["picture"] ==
                                null) {
                          ShowMessage.showMessage(
                              context, "Please Choose Image First");
                        } else {
                          if (nameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              phoneController.text.isEmpty) {
                            ShowMessage.showMessage(
                                context, "Make Sure all data filled");
                          } else {
                            String imageString = "";
                            if (image != null) {
                              final storageRef = FirebaseStorage.instance.ref();
                              final mountainImagesRef =
                                  storageRef.child("images/${image!.name}");

                              try {
                                var response = await mountainImagesRef
                                    .putFile(File(image!.path));

                                imageString =
                                    await response.ref.getDownloadURL();
                              } catch (e) {
                                print(e.toString());
                              }
                            }
                            await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(SharedHelper.getUserId())
                                .update(
                              {
                                "email": emailController.text,
                                "name": nameController.text,
                                "phone": phoneController.text,
                                "picture": image == null
                                    ? UserCubit.get(context).userData["picture"]
                                    : imageString,
                              },
                            ).then((value) {
                              UserCubit.get(context)
                                  .getUserData()
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            });
                          }
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                      color: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textColor: Colors.white,
                      child: const Text("Save Data"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
