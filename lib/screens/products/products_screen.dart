import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';

import '../../cubits/user/user_cubit.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({super.key});

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
                hintText: "Product Name, Category",
                onChanged: (value) {
                  cubit.searchProduct(searchController.text);
                },
                trailing: [
                  IconButton(
                    onPressed: () {
                      cubit.searchProduct(searchController.text);
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
            ),
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                return cubit.productsSearch.isEmpty
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                cubit.productsData[index]
                                                    ["picture"],
                                              ),
                                              radius: 40,
                                            ),
                                            const SizedBox(width: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  cubit.productsData[index]
                                                      ["name"],
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  cubit.productsData[index]
                                                      ["desc"],
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(cubit.productsData[index]
                                                        ["price"]
                                                    .toString()),
                                                Text(cubit.productsData[index]
                                                    ["category"]),
                                              ],
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            SharedHelper.setProductToCart(
                                                cubit.productsData[index],
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
                              itemCount: cubit.productsData.length,
                            ),
                          )
                        : const Center(child: Text("No Products Found"))
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            cubit.productsSearch[index]
                                                ["picture"],
                                          ),
                                          radius: 40,
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cubit.productsSearch[index]
                                                  ["name"],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              cubit.productsSearch[index]
                                                  ["desc"],
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(cubit.productsSearch[index]
                                                    ["price"]
                                                .toString()),
                                            Text(cubit.productsSearch[index]
                                                ["category"]),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        SharedHelper.setProductToCart(
                                            cubit.productsData[index], context);
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
                          itemCount: cubit.productsSearch.length,
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
