part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

final class HomeUpdateStatusPostEvent extends HomeEvent {
  final int index;
  final Posts postModel;

  HomeUpdateStatusPostEvent({required this.index, required this.postModel});
}

final class HomeDeletePostEvent extends HomeEvent {
  final Posts postModel;

  HomeDeletePostEvent({required this.postModel});
}

final class HomePostUndoDeleteEvent extends HomeEvent {}
