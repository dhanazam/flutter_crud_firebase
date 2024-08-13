part of 'home_bloc.dart';

enum HomeStatus { loading, unAuthorized, failure, logout, success }

extension HomeStatusX on HomeStatus {
  bool get isLoading => this == HomeStatus.loading;
  bool get isAuthirized => this == HomeStatus.unAuthorized;
  bool get isFailure => this == HomeStatus.failure;
  bool get isLogout => this == HomeStatus.logout;
  bool get isSuccess => this == HomeStatus.success;
}

final class HomeState extends Equatable {
  final HomeStatus status;
  final String toastMessage;
  final List<Posts> list;
  final Posts? lastDeletedPost;

  const HomeState({
    this.status = HomeStatus.loading,
    this.toastMessage = '',
    this.list = const [],
    this.lastDeletedPost,
  });

  HomeState copyWith({
    HomeStatus? status,
    String? toastMessage,
    List<Posts>? list,
    Posts? lastDeletedPost,
  }) {
    return HomeState(
      status: status ?? this.status,
      toastMessage: toastMessage ?? this.toastMessage,
      list: list ?? this.list,
      lastDeletedPost: lastDeletedPost ?? this.lastDeletedPost,
    );
  }

  @override
  List<Object?> get props => [status, toastMessage, list, lastDeletedPost];
}
