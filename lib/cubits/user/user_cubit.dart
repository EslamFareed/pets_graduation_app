import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../core/local/shared_helper.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  static UserCubit get(context) => BlocProvider.of(context);

  List<Map> productsData = [];
  List<Map> doctorsData = [];
  List<Map> clinicsData = [];
  List<Map> ordersData = [];

  bool isLoading = false;

  final firestore = FirebaseFirestore.instance;

  void getOrders() async {
    emit(GetOrdersLoadingState());
    try {
      var response = await firestore
          .collection("orders")
          .where("userId", isEqualTo: SharedHelper.getUserId())
          .get();

      ordersData = response.docs.map((e) => e.data()).toList();
      emit(GetOrdersSuccessState());
    } catch (e) {
      print(e.toString());
      emit(GetOrdersErrorState());
    }
  }

  void getData() async {
    isLoading = true;
    emit(GetDataLoadingState());

    try {
      var productsResponse = await firestore.collection("products").get();

      productsData = productsResponse.docs.map((e) => e.data()).toList();
    } catch (e) {
      print(e.toString());
    }

    try {
      var doctorsResponse = await firestore.collection("doctors").get();

      doctorsData = doctorsResponse.docs
          .map((e) => {
                "id": e.id,
                "address": e.data()["address"],
                "name": e.data()["name"],
                "picture": e.data()["picture"],
                "rate": e.data()["rate"],
                "specialization": e.data()["specialization"],
                "type": e.data()["type"],
              })
          .toList();
    } catch (e) {
      print(e.toString());
    }

    try {
      var clinicsResponse =
          await firestore.collection("clincsPharamacies").get();

      clinicsData = clinicsResponse.docs.map((e) => e.data()).toList();
    } catch (e) {
      print(e.toString());
    }

    isLoading = false;
    emit(GetDataSuccessState());
  }

  List<Map> doctorsSearch = [];

  void searchDoctor(String search) {
    doctorsSearch = doctorsData
        .where(
          (e) =>
              e["name"]
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              e["specialization"]
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              e["address"]
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()),
        )
        .toList();
    emit(SearchDoctorsState());
  }

  List<Map> productsSearch = [];

  void searchProduct(String search) {
    productsSearch = productsData
        .where(
          (e) =>
              e["name"]
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              e["category"]
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()),
        )
        .toList();
    emit(SearchProductsState());
  }

  List<Map> clinicsSearch = [];

  void searchClinics(String search) {
    clinicsSearch = clinicsData
        .where(
          (e) =>
              e["name"]
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              e["category"]
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              e["location"]
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()),
        )
        .toList();
    emit(SearchClinicsState());
  }

  Map<String, dynamic> userData = {};
  bool isLoadingUserData = false;

  Future<void> getUserData() async {
    emit(GetUserDataLoadingState());
    isLoadingUserData = true;
    try {
      var userResponse = await firestore
          .collection("Users")
          .doc(SharedHelper.getUserId())
          .get();

      userData = userResponse.data()!;
      emit(GetUserDataSuccessState());
    } catch (e) {
      print(e.toString());
      emit(GetUserDataErrorState());
    }
    isLoadingUserData = false;
  }
}
