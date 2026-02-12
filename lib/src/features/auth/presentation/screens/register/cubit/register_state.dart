part of 'register_cubit.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String? message;
  final RegisterResponseModel? registerResponseModel;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.message,
    this.registerResponseModel,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? message,
    RegisterResponseModel? registerResponseModel,
  }) {
    return RegisterState(
      status: status ?? this.status,
      message: message ?? this.message,
      registerResponseModel:
          registerResponseModel ?? this.registerResponseModel,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        registerResponseModel,
      ];
}
