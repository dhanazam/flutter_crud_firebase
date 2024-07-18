import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/core/core.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository = AuthRepository();
  SplashBloc() : super(const SplashState()) {
    on<SplashInitialEvent>(_onSplashInitialEvent);
  }

  Future<void> _onSplashInitialEvent(
      SplashInitialEvent event, Emitter<SplashState> emit) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi);
    emit(state.copyWith(status: SplashStatus.loading));
    UserModel user = await _authRepository.retrieveCurrentUser().first;
    if (user.uid != "uid") {
      emit(state.copyWith(status: SplashStatus.authorized));
    } else {
      emit(state.copyWith(status: SplashStatus.unAuthorized));
    }

    if (!hasInternet) {
      debugPrint('No Internet Connection');
      emit(
        state.copyWith(
          status: SplashStatus.failure,
          toastMessage: 'No Internet Connection',
        ),
      );
    }
  }
}
