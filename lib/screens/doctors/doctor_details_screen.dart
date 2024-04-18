import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:group_button/group_button.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubits/appointment/appointment_cubit.dart';

class DoctorDetailsScreen extends StatefulWidget {
  DoctorDetailsScreen({super.key, required this.doctor});

  Map doctor;

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  @override
  void initState() {
    AppointmentCubit.get(context).date = "";
    AppointmentCubit.get(context).chosenTime = "";
    super.initState();
  }

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    AppointmentCubit.get(context).getAppointments(widget.doctor["id"]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Make appointment"),
      ),
      body: ListView(
        children: [
          TimelineCalendar(
            calendarType: CalendarType.GREGORIAN,
            calendarLanguage: "en",
            calendarOptions: CalendarOptions(
              viewType: ViewType.DAILY,
              toggleViewType: false,
              headerMonthElevation: 10,
              headerMonthShadowColor: Colors.white,
              headerMonthBackColor: Colors.transparent,
            ),
            dayOptions: DayOptions(
                compactMode: true,
                weekDaySelectedColor: Colors.deepPurple,
                disableDaysBeforeNow: true),
            headerOptions: HeaderOptions(
                weekDayStringType: WeekDayStringTypes.SHORT,
                monthStringType: MonthStringTypes.FULL,
                backgroundColor: Colors.deepPurple,
                headerTextColor: Colors.white),
            onChangeDateTime: (datetime) {
              AppointmentCubit.get(context).changeDate(datetime.getDate());
              AppointmentCubit.get(context)
                  .getAppointments(widget.doctor["id"]);
            },
          ),
          const SizedBox(height: 25),
          Container(
            margin: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.doctor["picture"]),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.doctor["name"]),
                    Text(widget.doctor["address"]),
                    Text(widget.doctor["specialization"]),
                    Row(
                      children: [
                        Text("${widget.doctor["rate"]}"),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 25),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text("Time Schedule"),
          ),
          BlocBuilder<AppointmentCubit, AppointmentState>(
            builder: (context, state) {
              return state is LoadingGetAppointmentsState
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 3 / 2, crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        var item = AppointmentCubit.get(context)
                            .allAppointments[index];
                        return Container(
                          margin: const EdgeInsets.all(5),
                          child: MaterialButton(
                            onPressed: item["enable"]
                                ? () {
                                    AppointmentCubit.get(context)
                                        .chooseTime(item["time"]);
                                  }
                                : null,
                            disabledTextColor: Colors.black,
                            disabledColor: Colors.grey,
                            color: AppointmentCubit.get(context).chosenTime ==
                                    item["time"]
                                ? Colors.white
                                : Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: AppointmentCubit.get(context)
                                                .chosenTime ==
                                            item["time"]
                                        ? Colors.deepPurple
                                        : Colors.white),
                                borderRadius: BorderRadius.circular(16)),
                            textColor:
                                AppointmentCubit.get(context).chosenTime ==
                                        item["time"]
                                    ? Colors.black
                                    : Colors.white,
                            child: Text(
                              item["time"],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                      itemCount:
                          AppointmentCubit.get(context).allAppointments.length,
                    );
            },
          ),
          const SizedBox(height: 50),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: const Text("Choose Type"),
          ),
          GroupButton(
            isRadio: true,
            buttons: const ["on site", "from home"],
            onSelected: (value, index, isSelected) {
              AppointmentCubit.get(context).changeType(value);
            },
            options: GroupButtonOptions(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 50),
          BlocConsumer<AppointmentCubit, AppointmentState>(
            listener: (context, state) {
              if (state is SuccessMakeAppointmentsState) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return state is LoadingMakeAppointmentsState
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      margin: const EdgeInsets.all(20),
                      child: MaterialButton(
                        onPressed: () {
                          AppointmentCubit.get(context)
                              .makeAppointment(widget.doctor);
                        },
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text("Make An Appointment"),
                      ),
                    );
            },
          )
        ],
      ),
    );
  }
}
