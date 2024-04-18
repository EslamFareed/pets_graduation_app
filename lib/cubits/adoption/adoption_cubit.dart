import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';

part 'adoption_state.dart';

class AdoptionCubit extends Cubit<AdoptionState> {
  AdoptionCubit() : super(AdoptionInitial());

  static AdoptionCubit get(context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;
  List<Map> categories = [];

  void getCategories() async {
    emit(LoadingGetCategoriesState());

    try {
      var response = await firestore.collection("petCategories").get();
      categories = response.docs
          .map((e) => {
                "id": e.id,
                "name": e.data()["name"],
              })
          .toList();
      emit(SuccessGetCategoriesState());
    } catch (e) {
      print(e.toString());
      emit(ErrorGetCategoriesState());
    }
  }

  List<Map> animalsData = [];

  void getAllAnimals() async {
    emit(LoadingGetAllAnimalsState());

    try {
      var response = await firestore
          .collection("pets")
          .where("enabled", isEqualTo: true)
          .where("isAdopted", isEqualTo: false)
          .get();

      animalsData = response.docs
          .where((element) =>
              element.data()["ownerId"] != SharedHelper.getUserId())
          .toList()
          .map((e) => {
                "id": e.id,
                "category": e.data()["category"],
                "age": e.data()["age"],
                "desc": e.data()["desc"],
                "name": e.data()["name"],
                "gender": e.data()["gender"],
                "picture": e.data()["picture"],
                "ownerId": e.data()["ownerId"],
                "AdopterId": e.data()["AdopterId"],
                "enabled": e.data()["enabled"],
                "isAdopted": e.data()["isAdopted"],
              })
          .toList();
      emit(SuccessGetAllAnimalsState());
    } catch (e) {
      print(e.toString());
      emit(ErrorGetAllAnimalsState());
    }
  }

  Map ownerData = {};
  void getOwnerData(String id) async {
    emit(LoadingGetOwnerDataState());
    try {
      var response = await firestore.collection("Users").doc(id).get();

      ownerData = response.data() ?? {};

      emit(SuccessGetOwnerDataState());
    } catch (e) {
      print(e.toString());
      emit(ErrorGetOwnerDataState());
    }
  }

  void adoptPet(Map pet) async {
    emit(LoadingAdoptPetState());
    try {
      await firestore.collection("adoption").add({
        "adopterId": SharedHelper.getUserId(),
        "petId": pet["id"],
        "ownerId": pet["ownerId"],
        "date": DateTime.now().toString(),
      });
      await firestore.collection("pets").doc(pet["id"]).update({
        "category": pet["category"],
        "age": pet["age"],
        "desc": pet["desc"],
        "name": pet["name"],
        "gender": pet["gender"],
        "picture": pet["picture"],
        "ownerId": pet["ownerId"],
        "AdopterId": SharedHelper.getUserId(),
        "enabled": false,
        "isAdopted": true,
      });
      emit(SuccessAdoptPetState());
      getAllAnimals();
    } catch (e) {
      print(e.toString());
      emit(ErrorAdoptPetState());
    }
  }

  List<Map> filterAnimalsData = [];

  void filterAnimals(String cat) {
    
    filterAnimalsData = animalsData
        .where((element) => element["category"]["id"] == cat)
        .toList();
    
    emit(SuccessGetAllAnimalsState());
  }
}
