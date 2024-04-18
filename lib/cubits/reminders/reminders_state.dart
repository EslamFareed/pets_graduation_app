part of 'reminders_cubit.dart';

@immutable
sealed class RemindersState {}

final class RemindersInitial extends RemindersState {}

//! -------------------------------------------------------

class LoadingGetRemindersState extends RemindersState {}

class SuccessGetRemindersState extends RemindersState {}

class ErrorGetRemindersState extends RemindersState {}

//! -------------------------------------------------------
