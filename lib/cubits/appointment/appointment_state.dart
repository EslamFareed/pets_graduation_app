part of 'appointment_cubit.dart';

@immutable
sealed class AppointmentState {}

final class AppointmentInitial extends AppointmentState {}

//! ---------------------------------------------------------------

class ChangeDateState extends AppointmentState {}

//! ---------------------------------------------------------------

class LoadingGetAppointmentsState extends AppointmentState {}

class ErrorGetAppointmentsState extends AppointmentState {}

class SuccessGetAppointmentsState extends AppointmentState {}

//! ---------------------------------------------------------------

class ChooseTimeState extends AppointmentState {}

class ChooseTypeState extends AppointmentState {}
//! ---------------------------------------------------------------

class LoadingMakeAppointmentsState extends AppointmentState {}

class ErrorMakeAppointmentsState extends AppointmentState {}

class SuccessMakeAppointmentsState extends AppointmentState {}
