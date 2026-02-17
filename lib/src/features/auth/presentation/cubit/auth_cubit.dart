import 'package:autoglobal_camera_app/src/utils/validation.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../../di_injection.dart';
import '../../../../core/app/texts.dart';
import '../../../../core/configs/route_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/routing/route_generator.dart';
import '../../../../services/local/shared_preferences.dart';
import '../../data/models/login/login_request_model.dart';
import '../../domain/usecases/usecase.dart';

part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  //register
  //register form state
  final formKey = GlobalKey<FormState>();

  //remember me
  final ValueNotifier<bool> isRememberMe = ValueNotifier<bool>(false);

  //registers controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  //form handling
  bool isFormValid() {
    final formState = formKey.currentState;
    if (formState != null) {
      if (formState.validate()) {
        return true;
      }
    }
    return false;
  }

  String? isEmailValid(String? val) {
    if (val.toString().isEmpty || val == null) {
      return emptyText;
    }

    if (!val.toString().isValidEmail()) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? isPasswordValid(String? val) {
    if (val.toString().isEmpty || val == null) {
      return emptyText;
    }

    return null;
  }

  void reset() {
    _emailController.clear();
    _passwordController.clear();
  }

  LoginRequestModel sanitizedData() {
    return LoginRequestModel(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  void toggleRememberMe(bool data) async {
    SharedPreference.setRememberMe(data);
    isRememberMe.value = data;
  }

  Future<void> login() async {
    try {
      emit(
        state.copyWith(
          message: "Authenticating, please wait...",
          status: AuthStatus.loading,
        ),
      );

      final response = await getIt<LoginUsecase>().call(
        sanitizedData(),
      );
      await response.fold((failure) {
        emit(
          state.copyWith(message: failure.message, status: AuthStatus.failure),
        );
      }, (result) {
        SharedPreference.setAuthToken("${result.data?.token}");
        emit(
          state.copyWith(
            status: AuthStatus.success,
            message: result.message,
          ),
        );
      });
    } on ApiFailure catch (e) {
      emit(
        state.copyWith(
          message: e.message,
          status: AuthStatus.failure,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          status: AuthStatus.failure,
        ),
      );
    }
  }

  Future<void> logout() async {
    SharedPreference.resetCredentials();
    AppRouter().clearAndNavigate(RouteConfig.loginRoute);
  }
}
