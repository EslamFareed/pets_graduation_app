part of 'diagnose_cubit.dart';

@immutable
sealed class DiagnoseState {}

final class DiagnoseInitial extends DiagnoseState {}

//! ---------------------------------------------------------

class LoadingGetChatBoxOptionsState extends DiagnoseState {}

class SuccessGetChatBoxOptionsState extends DiagnoseState {}

class ErrorGetChatBoxOptionsState extends DiagnoseState {}
//! ---------------------------------------------------------

class ChangeSelectedItemState extends DiagnoseState {}

//! ---------------------------------------------------------

class LoadingGetCategoriesState extends DiagnoseState {}

class SuccessGetCategoriesState extends DiagnoseState {}

class ErrorGetCategoriesState extends DiagnoseState {}
//! ---------------------------------------------------------

class ChangeCategorySelectedItemState extends DiagnoseState {}
