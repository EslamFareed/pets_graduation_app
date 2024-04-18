import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';

part 'pets_state.dart';

class PetsCubit extends Cubit<PetsState> {
  PetsCubit() : super(PetsInitial());

  static PetsCubit get(context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;

  List<Map> myPets = [];

  List<Map> petCategories = [];

  void getCategories() async {
    emit(GetCategoriesLoadingState());
    try {
      var respones = await firestore.collection("petCategories").get();

      petCategories = respones.docs
          .map((e) => {
                "id": e.id,
                "name": e.data()["name"],
              })
          .toList();
      emit(GetCategoriesSuccessState());
    } catch (e) {
      print(e.toString());
      emit(GetCategoriesErrorState());
    }
  }

  void createPet(Map<String, dynamic> pet, XFile? image) async {
    emit(CreatePetLoadingState());
    try {
      String imageString = "";
      final storageRef = FirebaseStorage.instance.ref();
      final mountainImagesRef = storageRef.child("images/${image!.name}");

      try {
        var response = await mountainImagesRef.putFile(File(image.path));

        imageString = await response.ref.getDownloadURL();

        pet["picture"] = imageString;

        await firestore.collection('pets').add(pet);
        emit(CreatePetSuccessState());
        getPets();
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
      emit(CreatePetErrorState());
    }
  }

  void getPets() async {
    emit(GetPetsLoadingState());
    try {
      var response = await firestore.collection("pets").get();

      myPets = response.docs
          .where((element) =>
              element["ownerId"] == SharedHelper.getUserId() ||
              element["AdopterId"] == SharedHelper.getUserId())
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
      emit(GetPetsSuccessState());
    } catch (e) {
      print(e.toString());
      emit(GetPetsErrorState());
    }
  }

  void editPet(Map pet) async {
    emit(EditPetLoadingState());
    try {
      await firestore.collection("pets").doc(pet["id"]).update({
        "category": pet["category"],
        "age": pet["age"],
        "desc": pet["desc"],
        "name": pet["name"],
        "gender": pet["gender"],
        "picture": pet["picture"],
        "ownerId": pet["ownerId"],
        "AdopterId": pet["AdopterId"],
        "enabled": pet["enabled"],
        "isAdopted": pet["isAdopted"]
      });
      emit(EditPetSuccessState());

      getPets();
    } catch (e) {
      print(e.toString());
      emit(EditPetErrorState());
    }
  }
}
