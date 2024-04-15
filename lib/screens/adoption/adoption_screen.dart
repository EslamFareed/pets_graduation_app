import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/cubits/adoption/adoption_cubit.dart';
import 'package:pets_graduation_app/cubits/main/main_cubit.dart';
import 'package:pets_graduation_app/cubits/user/user_cubit.dart';
import 'package:pets_graduation_app/screens/adoption/pet_details_screen.dart';

class AdoptionScreen extends StatefulWidget {
  const AdoptionScreen({super.key});

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  @override
  void initState() {
    AdoptionCubit.get(context).getAllAnimals();
    AdoptionCubit.get(context).getCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Animals Ready for adoption"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          BlocBuilder<AdoptionCubit, AdoptionState>(
            builder: (context, state) {
              return state is LoadingGetCategoriesState
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final item =
                              AdoptionCubit.get(context).categories[index];
                          return InkWell(
                            onTap: () {
                              AdoptionCubit.get(context)
                                  .filterAnimals(item["id"]);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(5),
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(item["name"],
                                  style: const TextStyle(
                                      color: Colors.deepPurple)),
                            ),
                          );
                        },
                        itemCount: AdoptionCubit.get(context).categories.length,
                      ),
                    );
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<AdoptionCubit, AdoptionState>(
            builder: (context, state) {
              return state is LoadingGetAllAnimalsState
                  ? const Center(child: CircularProgressIndicator())
                  : AdoptionCubit.get(context).animalsData.isEmpty
                      ? const Center(
                          child: Text("No Animals Found"),
                        )
                      : AdoptionCubit.get(context).filterAnimalsData.isEmpty
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = AdoptionCubit.get(context)
                                    .animalsData[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                2,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                "${item["picture"]}"),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                    "${item["name"]} - ${item["age"]} years",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child:
                                                    Text("${item["gender"]}"),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                    "${item["category"]["name"]}"),
                                              ),
                                            ],
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              NavigationHelper.goTo(context,
                                                  PetDetailsScreen(item: item));
                                            },
                                            minWidth: 15,
                                            textColor: Colors.deepPurple,
                                            child: const Text(
                                              "View \nDetails",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount:
                                  AdoptionCubit.get(context).animalsData.length,
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = AdoptionCubit.get(context)
                                    .filterAnimalsData[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                2,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                "${item["picture"]}"),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                    "${item["name"]} - ${item["age"]} years",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child:
                                                    Text("${item["gender"]}"),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                    "${item["category"]["name"]}"),
                                              ),
                                            ],
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              NavigationHelper.goTo(context,
                                                  PetDetailsScreen(item: item));
                                            },
                                            minWidth: 15,
                                            textColor: Colors.deepPurple,
                                            child: const Text(
                                              "View \nDetails",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: AdoptionCubit.get(context)
                                  .filterAnimalsData
                                  .length,
                            );
            },
          )
        ],
      ),
    );
  }
}
