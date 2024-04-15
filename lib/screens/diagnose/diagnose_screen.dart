import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/cubits/diagnose/diagnose_cubit.dart';
import 'package:group_button/group_button.dart';

class DiagnoseScreen extends StatelessWidget {
  const DiagnoseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = DiagnoseCubit.get(context);
    cubit.getData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Diagnose"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Please Choose One of these options",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
          BlocBuilder<DiagnoseCubit, DiagnoseState>(
            builder: (context, state) {
              return state is LoadingGetChatBoxOptionsState
                  ? const Center(child: CircularProgressIndicator())
                  : state is ErrorGetChatBoxOptionsState
                      ? const Center(child: Text("Error in getting data"))
                      : GroupButton<Map>(
                          isRadio: true,
                          options: GroupButtonOptions(
                              selectedColor: Colors.grey[200],
                              selectedTextStyle:
                                  const TextStyle(color: Colors.black),
                              borderRadius: BorderRadius.circular(16),
                              unselectedColor: Colors.deepPurple,
                              unselectedTextStyle:
                                  const TextStyle(color: Colors.white)),
                          onSelected: (val, index, isSelected) {
                            cubit.selectItem(val);
                          },
                          buttonTextBuilder: (selected, value, context) {
                            return value["optionName"];
                          },
                          buttons: cubit.data.map((e) => e).toList(),
                        );
            },
          ),
          const SizedBox(height: 100),
          BlocBuilder<DiagnoseCubit, DiagnoseState>(
            builder: (context, state) {
              return Center(
                child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        cubit.selectedItem["textMessage"] ??
                            "No Option Selected",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
