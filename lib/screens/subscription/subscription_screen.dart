import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/cubits/user/user_cubit.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Subscription"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Container(
                width: MediaQuery.sizeOf(context).width * .7,
                height: MediaQuery.sizeOf(context).height * .4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/images/logo.jpg",
                      fit: BoxFit.cover,
                      width: MediaQuery.sizeOf(context).width * .4,
                    ),
                    const Text(
                      "You are now Normal User, You Want to subscribe,\nPlease Make a Request",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : MaterialButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      FirebaseFirestore.instance.collection("vipRequests").add({
                        "userId": SharedHelper.getUserId(),
                        "name": UserCubit.get(context).userData["name"],
                        "phone": UserCubit.get(context).userData["phone"],
                        "email": UserCubit.get(context).userData["email"],
                        "date": DateTime.now().toString(),
                        "accepted": false,
                      }).then((value) {
                        Navigator.pop(context);
                      });
                    },
                    minWidth: MediaQuery.sizeOf(context).width * .7,
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    child: const Text("Make Request For Vip"),
                  )
          ],
        ),
      ),
    );
  }
}
