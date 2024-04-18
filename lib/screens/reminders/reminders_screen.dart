import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/core/utils/navigation_helper.dart';
import 'package:pets_graduation_app/core/utils/show_message.dart';
import 'package:pets_graduation_app/cubits/reminders/reminders_cubit.dart';
import 'package:pets_graduation_app/screens/reminders/create_reminder_screen.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  void initState() {
    RemindersCubit.get(context).getReminders();
    super.initState();
  }

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Reminders"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigationHelper.goTo(context, CreateReminderScreen());
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<RemindersCubit, RemindersState>(
        builder: (context, state) {
          return state is LoadingGetRemindersState
              ? const Center(child: CircularProgressIndicator())
              : RemindersCubit.get(context).reminders.isEmpty
                  ? const Center(
                      child: Text("No Reminders Try to Create One"),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        var item = RemindersCubit.get(context).reminders[index];
                        return Card(
                          child: ListTile(
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return BottomSheet(
                                    onClosing: () {},
                                    builder: (context) {
                                      return SizedBox(
                                        width: MediaQuery.sizeOf(context).width,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                .2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MaterialButton(
                                              onPressed: () async {
                                                if (item["enabled"]) {
                                                  await Alarm.stop(item["count"]);
                                                }
                                                firestore
                                                    .collection("reminders")
                                                    .doc(item["id"])
                                                    .delete()
                                                    .then((value) {
                                                  RemindersCubit.get(context)
                                                      .getReminders();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              color: Colors.red,
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  .05,
                                              minWidth:
                                                  MediaQuery.sizeOf(context)
                                                          .width *
                                                      .8,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              textColor: Colors.white,
                                              child:
                                                  const Text("Delete Reminder"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                              // ShowMessage.showMessage(context, "Item Removed");
                            },
                            title: Text("Label : ${item["label"]}"),
                            subtitle: Text(
                                "${item["desc"]}\n${item["time"]}\n${item["enabled"] ? "Not Yet" : "Finished"}"),
                            trailing: Switch(
                              activeColor: Colors.deepPurple,
                              value: item["enabled"],
                              onChanged: (value) {
                                if (item["enabled"]) {
                                  firestore
                                      .collection("reminders")
                                      .doc(item["id"])
                                      .update({
                                    "enabled": false,
                                  }).then((v) {
                                    Alarm.stop(item["count"]).then((v) {
                                      setState(() {
                                        item["enabled"] = value;
                                      });
                                    });
                                  });
                                } else {
                                  ShowMessage.showMessage(context,
                                      "This Reminder is finished, try to create another one");
                                }
                              },
                            ),
                          ),
                        );
                      },
                      itemCount: RemindersCubit.get(context).reminders.length,
                    );
        },
      ),
    );
  }
}
