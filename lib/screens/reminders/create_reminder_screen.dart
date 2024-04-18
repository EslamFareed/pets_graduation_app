import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/cubits/reminders/reminders_cubit.dart';

class CreateReminderScreen extends StatelessWidget {
  CreateReminderScreen({super.key});

  final labelController = TextEditingController();
  final descController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  DateTime? date;
  TimeOfDay? time;

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Create Reminder"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: labelController,
              decoration: const InputDecoration(labelText: "Label"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              onTap: () async {
                date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2025),
                );

                dateController.text =
                    "${date!.year} - ${date!.month} - ${date!.day}";
              },
              controller: dateController,
              decoration: const InputDecoration(labelText: "Day"),
            ),
            TextField(
              onTap: () async {
                time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                timeController.text = time!.format(context);
                print(time);
              },
              controller: timeController,
              decoration: const InputDecoration(labelText: "Time"),
            ),
            const SizedBox(height: 50),
            BlocConsumer<RemindersCubit, RemindersState>(
              listener: (context, state) {
                if (state is SuccessGetRemindersState) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return state is LoadingGetRemindersState
                    ? const Center(child: CircularProgressIndicator())
                    : MaterialButton(
                        onPressed: () {
                          var dateTime = DateTime(date!.year, date!.month,
                              date!.day, time!.hour, time!.minute);
                          int count = Alarm.getAlarms().length;
                          firestore.collection("reminders").add({
                            "userId": SharedHelper.getUserId(),
                            "label": labelController.text,
                            "desc": descController.text,
                            "enabled": true,
                            "time": dateTime.toString(),
                            "count": count + 1,
                          }).then((value) async {
                            final alarmSettings = AlarmSettings(
                              id: count + 1,
                              dateTime: dateTime,
                              assetAudioPath: 'assets/songs/alarm.mp3',
                              loopAudio: true,
                              vibrate: true,
                              volume: 1.0,
                              fadeDuration: 3.0,
                              notificationTitle: labelController.text,
                              notificationBody: descController.text,
                              enableNotificationOnKill: true,
                            );

                            await Alarm.set(alarmSettings: alarmSettings)
                                .then((value) {
                              RemindersCubit.get(context).getReminders();
                            });
                          });
                        },
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: const Text("Create Reminder"),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
