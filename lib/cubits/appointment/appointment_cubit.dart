import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../core/local/shared_helper.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit() : super(AppointmentInitial());

  static AppointmentCubit get(context) => BlocProvider.of(context);

  String chooseType = "";
  void changeType(String type) {
    chooseType = type;
    emit(ChooseTypeState());
  }

  String date = "";

  void changeDate(String d) {
    date = d;
    chosenTime = "";
    emit(ChangeDateState());
  }

  List<Map> appointments = [];

  final firestore = FirebaseFirestore.instance;

  List<String> allTimes = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM",
    "08:00 PM",
    "09:00 PM",
    "10:00 PM",
  ];

  List<Map> allAppointments = [];

  String chosenTime = "";

  void chooseTime(String time) async {
    chosenTime = time;

    emit(ChooseTimeState());
  }

  void getAppointments(String doctorId) async {
    emit(LoadingGetAppointmentsState());
    try {
      var response = await firestore
          .collection("appointments")
          .where("doctorId", isEqualTo: doctorId)
          .get();

      appointments = response.docs
          .map((e) => {
                "id": e.id,
                "doctorId": e.data()["doctorId"],
                "userId": e.data()["userId"],
                "time": e.data()["time"],
                "day": e.data()["day"],
                "type": e.data()["type"],
              })
          .toList();

      allAppointments = allTimes
          .map((e) => {
                "time": e,
                "enable": appointments
                    .where((element) =>
                        element["day"] == date && element["time"] == e)
                    .isEmpty
              })
          .toList();

      emit(SuccessGetAppointmentsState());
    } catch (e) {
      print(e.toString());
      emit(ErrorGetAppointmentsState());
    }
  }

  void makeAppointment(String doctorId) async {
    emit(LoadingMakeAppointmentsState());
    try {
      await firestore.collection("appointments").add({
        "userId": SharedHelper.getUserId(),
        "doctorId": doctorId,
        "day": date,
        "time": chosenTime,
        "type": chooseType,
      });
      emit(SuccessMakeAppointmentsState());
    } catch (e) {
      print(e.toString());
      emit(ErrorMakeAppointmentsState());
    }
  }
}
