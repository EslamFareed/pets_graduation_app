part of 'adoption_cubit.dart';

@immutable
sealed class AdoptionState {}

final class AdoptionInitial extends AdoptionState {}

//! -------------------------------------------------------

class LoadingGetAllAnimalsState extends AdoptionState {}

class SuccessGetAllAnimalsState extends AdoptionState {}

class ErrorGetAllAnimalsState extends AdoptionState {}

//! -------------------------------------------------------

class LoadingGetCategoriesState extends AdoptionState {}

class SuccessGetCategoriesState extends AdoptionState {}

class ErrorGetCategoriesState extends AdoptionState {}

//! -------------------------------------------------------
class LoadingGetOwnerDataState extends AdoptionState {}

class SuccessGetOwnerDataState extends AdoptionState {}

class ErrorGetOwnerDataState extends AdoptionState {}

//! -------------------------------------------------------

class LoadingAdoptPetState extends AdoptionState {}

class SuccessAdoptPetState extends AdoptionState {}

class ErrorAdoptPetState extends AdoptionState {}
