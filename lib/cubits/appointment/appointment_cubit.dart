import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pets_graduation_app/cubits/user/user_cubit.dart';

import '../../core/local/shared_helper.dart';
import 'package:intl/intl.dart';

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

  void makeAppointment(Map doctor, BuildContext context) async {
    emit(LoadingMakeAppointmentsState());
    try {
      if (UserCubit.get(context).userData["isVip"]) {
        DateFormat format = DateFormat("yyyy-MM-dd hh:mm aaa");
        DateTime dateTime = format.parse("$date $chosenTime");

        int count = Alarm.getAlarms().length;
        await firestore.collection("reminders").add({
          "userId": SharedHelper.getUserId(),
          "label": "Appointment with Dr. ${doctor["name"]}",
          "desc":
              "Appointment with Dr. ${doctor["name"]} on $date at $chosenTime - $chooseType",
          "enabled": true,
          "time": dateTime.subtract(const Duration(hours: 1)).toString(),
          "count": count + 1,
        }).then((value) async {
          final alarmSettings = AlarmSettings(
            id: count + 1,
            dateTime: dateTime.subtract(const Duration(hours: 1)),
            assetAudioPath: 'assets/songs/alarm.mp3',
            loopAudio: true,
            vibrate: true,
            volume: 1.0,
            fadeDuration: 3.0,
            notificationTitle: "Appointment with ${doctor["name"]}",
            notificationBody:
                "Appointment with ${doctor["name"]} on $date at $chosenTime - $chooseType",
            enableNotificationOnKill: true,
          );

          await Alarm.set(alarmSettings: alarmSettings);
        });
      }
      await firestore.collection("appointments").add({
        "userId": SharedHelper.getUserId(),
        "doctorId": doctor["id"],
        "day": date,
        "time": chosenTime,
        "type": chooseType,
        "doctorName": doctor["name"],
        "done": false,
      });
      emit(SuccessMakeAppointmentsState());
    } catch (e) {
      print(e.toString());
      emit(ErrorMakeAppointmentsState());
    }
  }

  List<Map> myAppointments = [];

  void getMyAppointments() async {
    emit(LoadingGetMyAppointmentsState());
    try {
      var response = await firestore
          .collection("appointments")
          .where("userId", isEqualTo: SharedHelper.getUserId())
          .get();

      myAppointments = response.docs
          .map((e) => {
                "id": e.id,
                "userId": e.data()["userId"],
                "doctorId": e.data()["doctorId"],
                "day": e.data()["day"],
                "time": e.data()["time"],
                "type": e.data()["type"],
                "doctorName": e.data()["doctorName"],
                "done": e.data()["done"],
              })
          .toList();
      emit(SuccessGetMyAppointmentsState());
    } catch (e) {
      print(e.toString());
      emit(ErrorGetMyAppointmentsState());
    }
  }
}
