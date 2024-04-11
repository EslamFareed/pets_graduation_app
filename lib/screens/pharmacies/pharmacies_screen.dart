import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/user/user_cubit.dart';

class PharmaciesScreen extends StatelessWidget {
  PharmaciesScreen({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = UserCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Pharmacies / Clinics"),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: SearchBar(
                controller: searchController,
                hintText: "Clinic / Pharmacy Name, Category, Location",
                onChanged: (value) {
                  cubit.searchClinics(searchController.text);
                },
                trailing: [
                  IconButton(
                    onPressed: () {
                      cubit.searchClinics(searchController.text);
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
            ),
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                return cubit.clinicsSearch.isEmpty
                    ? searchController.text.isEmpty
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            UserCubit.get(context)
                                                .clinicsData[index]["picture"],
                                          ),
                                          radius: 40,
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              UserCubit.get(context)
                                                  .clinicsData[index]["name"],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              UserCubit.get(context)
                                                      .clinicsData[index]
                                                  ["category"],
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(UserCubit.get(context)
                                                    .clinicsData[index]
                                                ["location"]),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: cubit.clinicsData.length,
                            ),
                          )
                        : const Center(
                            child: Text("No Clinics / Pharmacies Found"))
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        UserCubit.get(context)
                                            .clinicsSearch[index]["picture"],
                                      ),
                                      radius: 40,
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          UserCubit.get(context)
                                              .clinicsSearch[index]["name"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          UserCubit.get(context)
                                              .clinicsSearch[index]["category"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(UserCubit.get(context)
                                            .clinicsSearch[index]["location"]),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: cubit.clinicsSearch.length,
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
