import 'package:flutter_bloc/flutter_bloc.dart';

class SidebarCubit extends Cubit<int> {
  SidebarCubit() : super(0);
  void changeScreen(int index) {
    emit(index);
  }
}
