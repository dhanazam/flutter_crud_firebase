import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_tab_state.dart';

class BottomTabCubit extends Cubit<BottomTabState> {
  BottomTabCubit() : super(const BottomTabState());

  void setTab(BottomTab tab) => emit(BottomTabState(tab: tab));
}
