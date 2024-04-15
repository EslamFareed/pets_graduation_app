import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'diagnose_state.dart';

class DiagnoseCubit extends Cubit<DiagnoseState> {
  DiagnoseCubit() : super(DiagnoseInitial());

  static DiagnoseCubit get(context) => BlocProvider.of(context);

  List<Map> data = [];

  final firestore = FirebaseFirestore.instance;

  Map selectedItem = {};

  void selectItem(Map selected) {
    selectedItem = selected;

    emit(ChangeSelectedItemState());
  }

  void getData() async {
    emit(LoadingGetChatBoxOptionsState());
    selectedItem = {};

    try {
      var response = await firestore.collection("chatBoxOptions").get();

      data = response.docs
          .map((e) => {
                "id": e.id,
                "optionName": e.data()["optionName"],
                "textMessage": e.data()["textMessage"],
              })
          .toList();

      emit(SuccessGetChatBoxOptionsState());
    } catch (e) {
      print(e.toString());
      emit(ErrorGetChatBoxOptionsState());
    }
  }

  List<Map> dataknowledges = [];
  Map selectedItemKnowledge = {};

  // void selectCategory(String cat) async {

  //   emit(ChangeCategorySelectedItemState());
  // }

  void selectItemKnowledge(Map selected) {
    selectedItemKnowledge = selected;

    emit(ChangeCategorySelectedItemState());
  }

  void getKnowledges() async {
    emit(LoadingGetCategoriesState());
    try {
      var response = await firestore.collection('knowledges').get();
      dataknowledges = response.docs
          .map((e) => {
                "id": e.id,
                "categoryId": e.data()["categoryId"],
                "categoryName": e.data()["categoryName"],
                "text": e.data()["text"],
              })
          .toList();
      emit(SuccessGetCategoriesState());
    } catch (e) {
      emit(ErrorGetCategoriesState());
    }
  }
}
