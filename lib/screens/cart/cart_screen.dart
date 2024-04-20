import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';

import 'make_order_screen.dart';

class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map> products = SharedHelper.getCart();

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Cart"),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              try {
                double total = 0;
                SharedHelper.getCart().forEach((element) {
                  total += double.parse(element["price"].toString()) *
                      int.parse(element["quantity"].toString());
                });

                firestore.collection("orders").add({
                  "userId": SharedHelper.getUserId(),
                  "items": SharedHelper.getCart(),
                  "total": total.toString(),
                  "date": DateTime.now().toString(),
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
            },
            icon: const Icon(Icons.shopping_cart_checkout),
          )
        ],
      ),
      body: products.isEmpty
          ? const Center(child: Text("No Products in Cart"))
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
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
                                    Text(products[index]["price"].toString()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  SharedHelper.addQuantity(
                                      products[index], context);
                                  products = SharedHelper.getCart();

                                  setState(() {});
                                },
                                icon: const Icon(Icons.add),
                              ),
                              Text("${products[index]["quantity"]}"),
                              IconButton(
                                onPressed: () {
                                  SharedHelper.mineseQuantity(
                                      products[index], context);
                                  products = SharedHelper.getCart();

                                  setState(() {});
                                },
                                icon: const Icon(Icons.minimize),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: products.length,
              ),
            ),
    );
  }
}
