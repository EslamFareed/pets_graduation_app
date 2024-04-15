import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/cubits/user/user_cubit.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserCubit.get(context).getOrders();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return state is GetOrdersLoadingState
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final item = UserCubit.get(context).ordersData[index];

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(item["date"].toString().split(" ")[0]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total = ${item["total"]}"),
                            const Text("Order Details : "),
                            const Divider(),
                            for (var e in item["items"])
                              Row(
                                children: [
                                  CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(e["picture"])),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("name : ${e["name"]}"),
                                      Text("category : ${e["category"]}"),
                                      Text("Price : ${e["price"]}"),
                                      Text("Quantity : ${e["quantity"]}"),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: UserCubit.get(context).ordersData.length,
                );
        },
      ),
    );
  }
}
