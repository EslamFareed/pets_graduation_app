part of 'pets_cubit.dart';

@immutable
sealed class PetsState {}

final class PetsInitial extends PetsState {}

//! ----------------------------------------------------------

class GetPetsLoadingState extends PetsState {}

class GetPetsSuccessState extends PetsState {}

class GetPetsErrorState extends PetsState {}

//! ----------------------------------------------------------

class CreatePetLoadingState extends PetsState {}

class CreatePetSuccessState extends PetsState {}

class CreatePetErrorState extends PetsState {}

//! ----------------------------------------------------------

class GetCategoriesLoadingState extends PetsState {}

class GetCategoriesSuccessState extends PetsState {}

class GetCategoriesErrorState extends PetsState {}

//! ----------------------------------------------------------
