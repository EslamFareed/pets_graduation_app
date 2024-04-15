import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';

import '../../cubits/diagnose/diagnose_cubit.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = DiagnoseCubit.get(context);
    cubit.getKnowledges();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Knowledge"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text("Please Choose One Category"),
          ),
          const SizedBox(height: 100),
          BlocBuilder<DiagnoseCubit, DiagnoseState>(
            builder: (context, state) {
              return state is LoadingGetCategoriesState
                  ? const Center(child: CircularProgressIndicator())
                  : state is ErrorGetCategoriesState
                      ? const Center(child: Text("Error in getting data"))
                      : GroupButton<Map>(
                          isRadio: true,
                          options: GroupButtonOptions(
                              selectedColor: Colors.deepPurple,
                              selectedTextStyle:
                                  const TextStyle(color: Colors.white),
                              borderRadius: BorderRadius.circular(16),
                              unselectedColor: Colors.white,
                              unselectedBorderColor: Colors.deepPurple,
                              unselectedTextStyle:
                                  const TextStyle(color: Colors.deepPurple)),
                          onSelected: (val, index, isSelected) {
                            cubit.selectItemKnowledge(val);
                          },
                          buttonTextBuilder: (selected, value, context) {
                            return value["categoryName"];
                          },
                          buttons: cubit.dataknowledges,
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
                      cubit.selectedItemKnowledge["text"] ??
                          "No Option Selected",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
