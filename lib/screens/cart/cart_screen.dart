import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/core/utils/show_message.dart';
import 'package:pets_graduation_app/screens/cart/check_out_screen.dart';

import 'make_order_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map> products = SharedHelper.getCart();

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
              if (products.isEmpty) {
                ShowMessage.showMessage(context, "No Products in cart");
              } else {
                NavigationHelper.goTo(
                  context,
                  const CheckOutScreen(),
                );
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
