import 'package:flutter/material.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/screens/appointments/appointments_screen.dart';
import 'package:pets_graduation_app/screens/auth/login_screen.dart';
import 'package:pets_graduation_app/screens/editProfile/edit_profile_screen.dart';
import 'package:pets_graduation_app/screens/knowledge/knowledge_screen.dart';
import 'package:pets_graduation_app/screens/orders/orders_screen.dart';
import 'package:pets_graduation_app/screens/pets/my_pets_screen.dart';
import 'package:pets_graduation_app/screens/subscription/subscription_screen.dart';

import '../../core/utils/show_message.dart';
import '../../cubits/user/user_cubit.dart';
import '../reminders/reminders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Card(
            child: ListTile(
              onTap: () {
                NavigationHelper.goTo(context, MyPetsScreen());
              },
              title: const Text("My Pets"),
              leading: const Icon(Icons.pets),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                NavigationHelper.goTo(context, const OrdersScreen());
              },
              title: const Text("Orders"),
              leading: const Icon(Icons.dashboard),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                NavigationHelper.goTo(context, EditProfileScreen());
              },
              title: const Text("Edit Profile"),
              leading: const Icon(Icons.person),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                if (UserCubit.get(context).userData["isVip"]) {
                  NavigationHelper.goTo(context, RemindersScreen());
                } else {
                  ShowMessage.showMessage(
                      context, "You Must subscribe to VIP ");
                }
              },
              title: const Text("Reminders"),
              leading: const Icon(Icons.notifications),
              trailing: UserCubit.get(context).userData["isVip"]
                  ? const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    )
                  : Container(
                      width: 100,
                      height: 25,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurple,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "For Vip Users",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                NavigationHelper.goTo(context, AppointmentsScreen());
              },
              title: const Text("Appointments"),
              leading: const Icon(Icons.calendar_today),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                NavigationHelper.goTo(context, KnowledgeScreen());
              },
              title: const Text("Knowledge"),
              leading: const Icon(Icons.info_rounded),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                NavigationHelper.goTo(context, SubscriptionScreen());
              },
              title: const Text("Subscription"),
              leading: const Icon(Icons.star),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                SharedHelper.logout().then((value) {
                  SharedHelper.setUserId("none").then((value) {
                    NavigationHelper.goToAndOffAll(context, LoginScreen());
                  });
                });
              },
              title: const Text("Log out"),
              leading: const Icon(Icons.logout),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
