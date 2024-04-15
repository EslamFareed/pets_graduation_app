import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/cubits/appointment/appointment_cubit.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppointmentCubit.get(context).getMyAppointments();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Appointments"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          return state is LoadingGetMyAppointmentsState
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final item =
                        AppointmentCubit.get(context).myAppointments[index];
                    return Card(
                      child: ListTile(
                        title: Text(item["doctorName"]),
                        subtitle: Text(
                            "${item["day"]} - ${item["time"]} \n${item["type"]}\n${item["done"] ? "Finished" : "Not Finished"}"),
                      ),
                    );
                  },
                  itemCount:
                      AppointmentCubit.get(context).myAppointments.length,
                );
        },
      ),
    );
  }
}
