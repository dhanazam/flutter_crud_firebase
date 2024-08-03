part of 'splash_bloc.dart';

final class SplashState extends Equatable {
  final bool hasConnectivity;
  final String toastMessage;

  const SplashState({
    this.hasConnectivity = false,
    this.toastMessage = '',
  });

  SplashState copyWith({
    bool? hasConnectivity,
    String? toastMessage,
  }) {
    return SplashState(
      hasConnectivity: hasConnectivity ?? this.hasConnectivity,
      toastMessage: toastMessage ?? this.toastMessage,
    );
  }

  @override
  List<Object?> get props => [hasConnectivity, toastMessage];
}
