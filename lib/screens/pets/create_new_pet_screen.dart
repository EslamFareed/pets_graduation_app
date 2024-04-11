import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/core/utils/show_message.dart';
import 'package:pets_graduation_app/cubits/pets/pets_cubit.dart';

class CreateNewPetScreen extends StatefulWidget {
  CreateNewPetScreen({super.key});

  @override
  State<CreateNewPetScreen> createState() => _CreateNewPetScreenState();
}

class _CreateNewPetScreenState extends State<CreateNewPetScreen> {
  final nameController = TextEditingController();

  final ageController = TextEditingController();

  final descController = TextEditingController();

  String? gender;

  Map? category;

  bool enabled = false;

  XFile? image;

  @override
  void initState() {
    PetsCubit.get(context).getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Pet"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: ListView(
          children: [
            image == null
                ? const CircleAvatar(
                    radius: 70,
                    backgroundImage:
                        AssetImage("assets/images/placeholder.jpg"),
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
                child: const Text("Choose Image"),
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Age",
              ),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<PetsCubit, PetsState>(
              builder: (context, state) {
                return state is GetCategoriesLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButton(
                        isExpanded: true,
                        value: category,
                        hint: const Text("Choose Category"),
                        items: PetsCubit.get(context)
                            .petCategories
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e["name"],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            category = value;
                          });
                        },
                      );
              },
            ),
            const SizedBox(height: 20),
            DropdownButton(
              hint: const Text("Choose Gender"),
              isExpanded: true,
              value: gender,
              items: const [
                DropdownMenuItem(
                  value: "Male",
                  child: Text("Male"),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
              },
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text("This Pet Ready for adoption"),
              value: enabled,
              onChanged: (value) {
                setState(() {
                  enabled = value;
                });
              },
            ),
            const SizedBox(height: 50),
            BlocConsumer<PetsCubit, PetsState>(
              listener: (context, state) {
                if (state is GetPetsSuccessState) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return state is CreatePetLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : MaterialButton(
                        onPressed: () async {
                          if (image == null ||
                              category == null ||
                              gender == null ||
                              nameController.text.isEmpty ||
                              ageController.text.isEmpty ||
                              descController.text.isEmpty) {
                            ShowMessage.showMessage(
                                context, "Please Enter All Fields");
                          } else {
                            PetsCubit.get(context).createPet({
                              "category": category,
                              "age": ageController.text,
                              "desc": descController.text,
                              "name": nameController.text,
                              "gender": gender,
                              "ownerId": SharedHelper.getUserId(),
                              "AdopterId": "",
                              "enabled": enabled,
                              "isAdopted": false,
                            }, image);
                          }
                        },
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textColor: Colors.white,
                        child: const Text("Create New Pet"),
                      );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
