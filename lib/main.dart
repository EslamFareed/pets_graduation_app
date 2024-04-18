import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_graduation_app/core/local/shared_helper.dart';
import 'package:pets_graduation_app/cubits/adoption/adoption_cubit.dart';
import 'package:pets_graduation_app/cubits/appointment/appointment_cubit.dart';
import 'package:pets_graduation_app/cubits/diagnose/diagnose_cubit.dart';
import 'package:pets_graduation_app/cubits/main/main_cubit.dart';
import 'package:pets_graduation_app/cubits/pets/pets_cubit.dart';
import 'package:pets_graduation_app/cubits/reminders/reminders_cubit.dart';
import 'package:pets_graduation_app/cubits/user/user_cubit.dart';

import 'screens/start/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:alarm/alarm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    SharedHelper.init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    Alarm.init()
  ]);

  // Alarm.ringStream.stream.listen((alarm) {
  //   var counter = 60;
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     counter--;
  //     if (counter == 0) {
  //       timer.cancel();
  //       Alarm.stop(alarm.id);
  //     }
  //   });
  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => MainCubit()),
        BlocProvider(create: (context) => PetsCubit()),
        BlocProvider(create: (context) => DiagnoseCubit()),
        BlocProvider(create: (context) => AdoptionCubit()),
        BlocProvider(create: (context) => AppointmentCubit()),
        BlocProvider(create: (context) => RemindersCubit()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
