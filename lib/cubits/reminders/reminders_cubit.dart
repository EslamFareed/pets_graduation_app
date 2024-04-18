import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'reminders_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit() : super(RemindersInitial());

  static RemindersCubit get(context) => BlocProvider.of(context);

  final firestore = FirebaseFirestore.instance;

  List<Map> reminders = [];

  void getReminders() async {
    emit(LoadingGetRemindersState());

    try {
      var response = await firestore.collection("reminders").get();

      reminders = response.docs
          .map((e) => {
                "id": e.id,
                "label": e.data()["label"],
                "desc": e.data()["desc"],
                "time": e.data()["time"],
                "userId": e.data()["userId"],
                "enabled": e.data()["enabled"],
                "count": e.data()["count"],
              })
          .toList();

      emit(SuccessGetRemindersState());
    } catch (e) {
      print(e.toString());
      emit(ErrorGetRemindersState());
    }
  }
}
