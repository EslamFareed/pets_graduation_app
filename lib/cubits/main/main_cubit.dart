import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../screens/doctors/doctors_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/products/products_screen.dart';
import '../../screens/profile/profile_screen.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    HomeScreen(),
    DoctorsScreen(),
    ProductsScreen(),
    ProfileScreen(),
  ];
  int index = 0;

  void changeScreen(int i) {
    index = i;
    emit(ChangeBottomNavIndexState());
  }
}
