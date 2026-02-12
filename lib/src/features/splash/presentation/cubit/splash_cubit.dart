import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/development/console.dart';
import '../../../../services/local/shared_preferences.dart';

part 'splash_state.dart';

@lazySingleton
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  Future<void> afterAppUpdateAvailable({bool isAppUpdated = false}) async {
    if (isAppUpdated) {
      logger("message");
      emit(state.copyWith(
        message: "Inside Home",
        status: SplashStatus.loggedIn,
      ));
    } else {
      emit(state.copyWith(
        message: "insideLoginNoTokenText",
        status: SplashStatus.loggedOut,
      ));
    }
  }

  Future<void> getPreferences() async {
    try {
      print("Splash Initiated");
      emit(state.copyWith(
        message: "Initial",
        status: SplashStatus.initial,
      ));

      await Future.delayed(const Duration(seconds: 3));

      // if (SharedPreference.firstTimeInApp != null) {
      //   emit(state.copyWith(
      //     message: "Onboarding",
      //     status: SplashStatus.appFirstTime,
      //   ));
      //   return;
      // }

      if (SharedPreference.getSPToken != null) {
        emit(state.copyWith(
          message: "Logged In",
          status: SplashStatus.loggedIn,
        ));
      } else {
        emit(state.copyWith(
          message: "Logged Out",
          status: SplashStatus.loggedOut,
        ));
      }
    } catch (e) {
      consolelog(e.toString());
      emit(state.copyWith(
        message: "Logged Out",
        status: SplashStatus.loggedOut,
      ));
    }
  }

  Future<void> loggedIn() async {
    emit(state.copyWith(message: "Logged In", status: SplashStatus.loggedIn));
  }

  Future<void> loggedOut() async {
    emit(state.copyWith(message: "Logged Out", status: SplashStatus.loggedOut));
  }
}
