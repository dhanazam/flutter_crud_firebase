import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState()) {
    on<SplashInitialEvent>(_onSplashInitialEvent);
  }

  Future<void> _onSplashInitialEvent(
      SplashInitialEvent event, Emitter<SplashState> emit) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = connectivityResult.contains(ConnectivityResult.wifi);

    if (!hasInternet) {
      debugPrint('No Internet Connection');
      emit(state.copyWith(
        hasConnectivity: false,
        toastMessage: 'No Internet Connection',
      ));
    }
  }
}
