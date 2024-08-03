part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

final class HomeUpdateStatusPostEvent extends HomeEvent {
  final int index;
  final Post postModel;

  HomeUpdateStatusPostEvent({required this.index, required this.postModel});
}

final class HomeDeletePostEvent extends HomeEvent {
  final Post postModel;

  HomeDeletePostEvent({required this.postModel});
}
