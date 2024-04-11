import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/cubits/main/main_cubit.dart';
import 'package:pets_graduation_app/cubits/user/user_cubit.dart';
import 'package:pets_graduation_app/screens/cart/cart_screen.dart';
import 'package:pets_graduation_app/screens/doctors/doctors_screen.dart';
import 'package:pets_graduation_app/screens/home/home_screen.dart';
import 'package:pets_graduation_app/screens/profile/profile_screen.dart';

import '../products/products_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  void initState() {
    UserCubit.get(context).getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return UserCubit.get(context).isLoadingUserData
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : BlocBuilder<MainCubit, MainState>(
                builder: (context, state) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.deepPurple,
                      actions: [
                        IconButton(
                          onPressed: () {
                            NavigationHelper.goTo(context, CartScreen());
                          },
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                        )
                      ],
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                UserCubit.get(context).userData["picture"]),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Welcome, ${UserCubit.get(context).userData["name"]}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: MainCubit.get(context)
                        .screens[MainCubit.get(context).index],
                    bottomNavigationBar: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      items: const [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home), label: "Home"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.healing), label: "Doctors"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.store), label: "Products"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person), label: "Profile"),
                      ],
                      currentIndex: MainCubit.get(context).index,
                      onTap: (value) {
                        MainCubit.get(context).changeScreen(value);
                      },
                    ),
                  );
                },
              );
      },
    );
  }
}
