part of 'splash_bloc.dart';

enum SplashStatus {
  loading,
  authorized,
  unAuthorized,
  failure,
}

extension SplashStatusX on SplashStatus {
  bool get isLogin => this == SplashStatus.loading;
  bool get isAuthorized => this == SplashStatus.authorized;
  bool get isUnAuthorized => this == SplashStatus.unAuthorized;
  bool get isFailure => this == SplashStatus.failure;
}

final class SplashState extends Equatable {
  final SplashStatus status;
  final String toastMessage;

  const SplashState({
    this.status = SplashStatus.loading,
    this.toastMessage = '',
  });

  SplashState copyWith({
    SplashStatus? status,
    String? toastMessage,
  }) {
    return SplashState(
      status: status ?? this.status,
      toastMessage: toastMessage ?? this.toastMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, toastMessage];
}
