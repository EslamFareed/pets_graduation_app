import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'pets_state.dart';

class PetsCubit extends Cubit<PetsState> {
  PetsCubit() : super(PetsInitial());

  static PetsCubit get(context) => BlocProvider.of(context);
}
