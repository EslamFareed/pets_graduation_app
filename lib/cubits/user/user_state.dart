part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

//! ------------------------------------------

class GetDataLoadingState extends UserState {}

class GetDataSuccessState extends UserState {}

class GetDataErrorState extends UserState {}

//! ------------------------------------------

class SearchDoctorsState extends UserState {}

//! ------------------------------------------

class GetUserDataLoadingState extends UserState {}

class GetUserDataSuccessState extends UserState {}

class GetUserDataErrorState extends UserState {}

//! ------------------------------------------

class SearchProductsState extends UserState {}

//! ------------------------------------------

class SearchClinicsState extends UserState {}

//! ------------------------------------------
class GetOrdersLoadingState extends UserState {}

class GetOrdersSuccessState extends UserState {}

class GetOrdersErrorState extends UserState {}

//! ------------------------------------------
