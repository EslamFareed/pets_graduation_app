import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/show_message.dart';
import '../../cubits/pets/pets_cubit.dart';

class EditMyPetScreen extends StatefulWidget {
  EditMyPetScreen({super.key, required this.item});
  Map item;

  @override
  State<EditMyPetScreen> createState() => _EditMyPetScreenState();
}

class _EditMyPetScreenState extends State<EditMyPetScreen> {
  final nameController = TextEditingController();

  final ageController = TextEditingController();

  final descController = TextEditingController();

  bool enabled = false;

  @override
  void initState() {
    nameController.text = widget.item["name"];
    ageController.text = widget.item["age"];
    descController.text = widget.item["desc"];
    enabled = widget.item["enabled"];
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit My Pet"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: ListView(
          children: [
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
                return state is EditPetLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : MaterialButton(
                        onPressed: () async {
                          if (nameController.text.isEmpty ||
                              ageController.text.isEmpty ||
                              descController.text.isEmpty) {
                            ShowMessage.showMessage(
                                context, "Please Enter All Fields");
                          } else {
                            widget.item["name"] = nameController.text;
                            widget.item["age"] = ageController.text;
                            widget.item["desc"] = descController.text;
                            widget.item["enabled"] = enabled;
                            PetsCubit.get(context).editPet(widget.item);
                          }
                        },
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textColor: Colors.white,
                        child: const Text("Save Data"),
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
