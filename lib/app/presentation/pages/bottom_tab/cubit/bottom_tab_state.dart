part of 'bottom_tab_cubit.dart';

enum BottomTab { home, profile }

final class BottomTabState extends Equatable {
  const BottomTabState({this.tab = BottomTab.home});

  final BottomTab tab;

  @override
  List<Object> get props => [tab];
}
