import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';

import 'make_order_screen.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  List<Map> products = SharedHelper.getCart();

  final firestore = FirebaseFirestore.instance;

  double total = 0.0;

  var loading = false;

  final addressController = TextEditingController();

  String address = "";

  @override
  void initState() {
    for (var element in products) {
      total += double.parse(element["price"].toString()) *
          int.parse(element["quantity"].toString());
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Checkout"),
        foregroundColor: Colors.white,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       try {
        //         double total = 0;
        //         SharedHelper.getCart().forEach((element) {
        //           total += double.parse(element["price"].toString()) *
        //               int.parse(element["quantity"].toString());
        //         });
        //         firestore.collection("orders").add({
        //           "userId": SharedHelper.getUserId(),
        //           "items": SharedHelper.getCart(),
        //           "total": total.toString(),
        //           "date": DateTime.now().toString(),
        //         }).then((value) {
        //           SharedHelper.deleteCart().then((value) {
        //             NavigationHelper.goToAndOffAll(
        //               context,
        //               const MakeOrderScreen(),
        //             );
        //           });
        //         });
        //       } catch (e) {
        //         print(e.toString());
        //       }
        //     },
        //     icon: const Icon(Icons.shopping_cart_checkout),
        //   )
        // ],
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 150,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Delivery Address"),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            showDragHandle: true,
                            isScrollControlled: true,
                            enableDrag: true,
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Text("Enter Your Shipping Address"),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: addressController,
                                      decoration: InputDecoration(
                                        labelText: "Address",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 50),
                                    MaterialButton(
                                      minWidth:
                                          MediaQuery.sizeOf(context).width * .8,
                                      onPressed: () {
                                        setState(() {
                                          address = addressController.text;
                                        });

                                        Navigator.pop(context);
                                      },
                                      textColor: Colors.white,
                                      color: Colors.deepPurple,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: const Text("Save Address"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    address.isEmpty ? "No Location" : address,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                products[index]["picture"],
                              ),
                              radius: 40,
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    products[index]["name"],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("price : ${products[index]["price"]}"),
                                  Text(
                                      "Quantity : ${products[index]["quantity"]}"),
                                  Text(
                                      "Total : ${products[index]["quantity"] * double.parse(products[index]["price"])}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: products.length,
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 150,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Price"),
                    Text("$total"),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pay Type"),
                    Text("Cash"),
                  ],
                ),
              ],
            ),
          ),
          loading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  margin: const EdgeInsets.all(20),
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      try {
                        firestore.collection("orders").add({
                          "userId": SharedHelper.getUserId(),
                          "items": SharedHelper.getCart(),
                          "total": total.toString(),
                          "date": DateTime.now().toString(),
                          "address": address,
                        }).then((value) {
                          SharedHelper.deleteCart().then((value) {
                            NavigationHelper.goToAndOffAll(
                              context,
                              const MakeOrderScreen(),
                            );
                          });
                        });
                      } catch (e) {
                        print(e.toString());
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                    textColor: Colors.white,
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: const Text("Checkout"),
                  ),
                )
        ],
      ),
    );
  }
}
