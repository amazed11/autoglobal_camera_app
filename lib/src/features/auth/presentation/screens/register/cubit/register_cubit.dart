import 'package:autoglobal_camera_app/src/utils/validation.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../../di_injection.dart';
import '../../../../../../core/app/texts.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../services/local/shared_preferences.dart';
import '../../../../data/models/register/register_request_model.dart';
import '../../../../data/models/register/register_response_model.dart';
import '../../../../domain/usecases/usecase.dart';

part 'register_state.dart';

@lazySingleton
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  //register
  //register form state
  final formKey = GlobalKey<FormState>();
  final otpKey = GlobalKey<FormState>();

  //remember me
  final ValueNotifier<bool> acceptTerms = ValueNotifier<bool>(false);

  //registers controllers
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get phoneController => _phoneNameController;
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

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

  String? isEmailValid(String val) {
    if (val.toString().isEmpty) {
      return emptyText;
    }

    if (!val.toString().isValidEmail()) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? isPasswordValid(String val, TextEditingController controller) {
    if (val.toString().isEmpty) {
      return emptyText;
    }
    if (val.toString().length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (val.toString() != controller.text.trim()) {
      return 'Password does not match';
    }
    return null;
  }

  void reset() {
    _emailController.clear();
    _passwordController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneNameController.clear();
  }

  RegisterRequestModel sanitizedData() {
    return RegisterRequestModel(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneNameController.text.trim(),
    );
  }

  void toggleAcceptTerms() {
    acceptTerms.value = !acceptTerms.value;
  }

  Future<void> register() async {
    try {
      emit(
        state.copyWith(
          message: "Registering, please wait...",
          status: RegisterStatus.loading,
        ),
      );

      final response = await getIt<RegisterUsecase>().call(
        sanitizedData(),
      );
      await response.fold((failure) {
        emit(
          state.copyWith(
              message: failure.message, status: RegisterStatus.failure),
        );
      }, (result) async {
        if (result.data != null) {
          print("I am set auth token ${result.data?.token}");
          await SharedPreference.setAuthToken("${result.data?.token}");
        }
        emit(
          state.copyWith(
            status: RegisterStatus.success,
            message: "Registered successfully",
            registerResponseModel: result,
          ),
        );
      });
    } on ApiFailure catch (e) {
      emit(
        state.copyWith(
          message: e.message,
          status: RegisterStatus.failure,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          status: RegisterStatus.failure,
        ),
      );
    }
  }
}
