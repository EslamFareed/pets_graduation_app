import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/cubits/main/main_cubit.dart';
import 'package:pets_graduation_app/cubits/user/user_cubit.dart';
import 'package:pets_graduation_app/screens/pharmacies/pharmacies_screen.dart';

import '../../core/local/shared_helper.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<IconData> icons = const [
    (Icons.local_hospital),
    (Icons.calendar_today),
    (Icons.gesture),
    (Icons.healing),
    (Icons.local_shipping),
    (Icons.notifications),
  ];

  List<String> names = const [
    "Diagnose",
    "Appoinment",
    "Adoption",
    "Pharmacies",
    "Order",
    "Reminders",
  ];

  @override
  void initState() {
    UserCubit.get(context).getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return UserCubit.get(context).isLoading
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Services",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    break;
                                  case 1:
                                    MainCubit.get(context).changeScreen(1);
                                    break;
                                  case 2:
                                    break;
                                  case 3:
                                    NavigationHelper.goTo(
                                        context, PharmaciesScreen());
                                    break;
                                  case 4:
                                    MainCubit.get(context).changeScreen(2);
                                    break;
                                  case 5:
                                    break;
                                  default:
                                }
                              },
                              child: Card(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      icons[index],
                                      size: 50,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    Text(names[index])
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: 6,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Top Doctors",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
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
                                            .doctorsData[index]["picture"],
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
                                              .doctorsData[index]["name"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          UserCubit.get(context)
                                                  .doctorsData[index]
                                              ["specialization"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(UserCubit.get(context)
                                            .doctorsData[index]["type"]),
                                        Text(UserCubit.get(context)
                                            .doctorsData[index]["address"]),
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                color: Colors.yellow),
                                            Text(
                                                "${UserCubit.get(context).doctorsData[index]["rate"]}"),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount:
                              UserCubit.get(context).doctorsData.length > 3
                                  ? 3
                                  : UserCubit.get(context).doctorsData.length,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Top Products",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            UserCubit.get(context)
                                                .productsData[index]["picture"],
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
                                                  .productsData[index]["name"],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              UserCubit.get(context)
                                                  .productsData[index]["desc"],
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(UserCubit.get(context)
                                                .productsData[index]["price"]
                                                .toString()),
                                            Text(UserCubit.get(context)
                                                    .productsData[index]
                                                ["category"]),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        SharedHelper.setProductToCart(
                                            UserCubit.get(context)
                                                .productsData[index],
                                            context);
                                      },
                                      icon: const Icon(
                                        Icons.add_shopping_cart,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount:
                              UserCubit.get(context).productsData.length > 3
                                  ? 3
                                  : UserCubit.get(context).productsData.length,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Top Clinics / Pharmacies",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
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
                                              .clinicsData[index]["category"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(UserCubit.get(context)
                                            .clinicsData[index]["location"]),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount:
                              UserCubit.get(context).clinicsData.length > 3
                                  ? 3
                                  : UserCubit.get(context).clinicsData.length,
                        ),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}