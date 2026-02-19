part of 'car_permission_cubit.dart';

enum CarPermissionStatus { initial, loading, success, failure }

class CarPermissionState extends Equatable {
  final CarPermissionStatus status;
  final CarPermissionData? data;
  final String? message;

  const CarPermissionState({
    this.status = CarPermissionStatus.initial,
    this.data,
    this.message,
  });

  CarPermissionState copyWith({
    CarPermissionStatus? status,
    CarPermissionData? data,
    String? message,
  }) {
    return CarPermissionState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, data, message];
}
