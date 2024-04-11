import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/cubits/pets/pets_cubit.dart';
import 'package:pets_graduation_app/screens/pets/create_new_pet_screen.dart';

class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PetsCubit.get(context).getPets();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Pets"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              NavigationHelper.goTo(
                context,
                CreateNewPetScreen(),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: BlocBuilder<PetsCubit, PetsState>(
        builder: (context, state) {
          return state is GetPetsLoadingState
              ? const Center(child: CircularProgressIndicator())
              : PetsCubit.get(context).myPets.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("No Pets Found"),
                        MaterialButton(
                          onPressed: () {
                            NavigationHelper.goTo(
                              context,
                              CreateNewPetScreen(),
                            );
                          },
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          minWidth: MediaQuery.sizeOf(context).width * .7,
                          child: const Text("Add First Pet"),
                        )
                      ],
                    ))
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        final item = PetsCubit.get(context).myPets[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                "${item["name"]} - ${item["category"]["name"]}"),
                            subtitle: Text(
                                "Age : ${item["age"]}\n${item["enabled"] ? "Ready For Adoption" : "Not Ready For Adoption"}\n${item["gender"]}"),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(item["picture"]),
                            ),
                          ),
                        );
                      },
                      itemCount: PetsCubit.get(context).myPets.length,
                    );
        },
      ),
    );
  }
}
