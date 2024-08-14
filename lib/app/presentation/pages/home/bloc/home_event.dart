part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

final class HomeUpdateStatusPostEvent extends HomeEvent {
  final Post postModel;

  HomeUpdateStatusPostEvent({required this.postModel});
}

final class HomeDeletePostEvent extends HomeEvent {
  final Post postModel;

  HomeDeletePostEvent({required this.postModel});
}

final class HomePostUndoDeleteEvent extends HomeEvent {}

final class HomePostsFilterEvent extends HomeEvent {
  final PostsFilter filter;

  HomePostsFilterEvent({required this.filter});
}
