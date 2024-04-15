import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/cubits/user/user_cubit.dart';
import 'package:pets_graduation_app/screens/doctors/doctor_details_screen.dart';

class DoctorsScreen extends StatelessWidget {
  DoctorsScreen({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = UserCubit.get(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: SearchBar(
                controller: searchController,
                hintText: "Doctor Name, Specialization, Location",
                onChanged: (value) {
                  cubit.searchDoctor(searchController.text);
                },
                trailing: [
                  IconButton(
                    onPressed: () {
                      cubit.searchDoctor(searchController.text);
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
            ),
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                return cubit.doctorsSearch.isEmpty
                    ? searchController.text.isEmpty
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    NavigationHelper.goTo(
                                        context,
                                        DoctorDetailsScreen(
                                            doctor: cubit.doctorsData[index]));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          height: 100,
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  .5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                cubit.doctorsData[index]
                                                    ["picture"],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            "${cubit.doctorsData[index]["name"]}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  size: 16,
                                                  color: Colors.yellow),
                                              Text(cubit.doctorsData[index]
                                                      ["rate"]
                                                  .toString())
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                              "${cubit.doctorsData[index]["address"]}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: cubit.doctorsData.length,
                            ),
                            // child: ListView.builder(
                            // physics: const NeverScrollableScrollPhysics(),
                            // shrinkWrap: true,
                            //   itemBuilder: (context, index) {
                            //     return Card(
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Row(
                            //           children: [
                            //             CircleAvatar(
                            //               backgroundImage: NetworkImage(
                            //                 cubit.doctorsData[index]["picture"],
                            //               ),
                            //               radius: 40,
                            //             ),
                            //             const SizedBox(width: 20),
                            //             Column(
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   cubit.doctorsData[index]["name"],
                            //                   style: const TextStyle(
                            //                     fontSize: 15,
                            //                     fontWeight: FontWeight.bold,
                            //                   ),
                            //                 ),
                            //                 Text(
                            //                   cubit.doctorsData[index]
                            //                       ["specialization"],
                            //                   style: const TextStyle(
                            //                     fontSize: 15,
                            //                   ),
                            //                 ),
                            //                 Text(cubit.doctorsData[index]
                            //                     ["type"]),
                            //                 Text(cubit.doctorsData[index]
                            //                     ["address"]),
                            //                 Row(
                            //                   children: [
                            //                     const Icon(Icons.star,
                            //                         color: Colors.yellow),
                            //                     Text(
                            //                         "${cubit.doctorsData[index]["rate"]}"),
                            //                   ],
                            //                 )
                            //               ],
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     );
                            //   },
                            //   itemCount: cubit.doctorsData.length,
                            // ),
                          )
                        : const Center(child: Text("No Doctors Found"))
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
                                        cubit.doctorsSearch[index]["picture"],
                                      ),
                                      radius: 40,
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cubit.doctorsSearch[index]["name"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          cubit.doctorsSearch[index]
                                              ["specialization"],
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                            cubit.doctorsSearch[index]["type"]),
                                        Text(cubit.doctorsSearch[index]
                                            ["address"]),
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                color: Colors.yellow),
                                            Text(
                                                "${cubit.doctorsSearch[index]["rate"]}"),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: cubit.doctorsSearch.length,
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
