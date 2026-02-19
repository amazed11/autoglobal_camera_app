part of 'car_damage_cubit.dart';

enum CarDamageStatus {
  initial,
  loadingParts,
  partsLoaded,
  submitting,
  submitted,
  failure
}

class CarDamageState extends Equatable {
  final CarDamageStatus status;
  final CarDamageData? data;
  final String? message;

  /// partKey → set of selected option keys
  final Map<String, Set<String>> selection;

  const CarDamageState({
    this.status = CarDamageStatus.initial,
    this.data,
    this.message,
    this.selection = const {},
  });

  CarDamageState copyWith({
    CarDamageStatus? status,
    CarDamageData? data,
    String? message,
    Map<String, Set<String>>? selection,
  }) =>
      CarDamageState(
        status: status ?? this.status,
        data: data ?? this.data,
        message: message ?? this.message,
        selection: selection ?? this.selection,
      );

  /// Total number of parts that have at least one option selected
  int get selectedPartCount =>
      selection.entries.where((e) => e.value.isNotEmpty).length;

  @override
  List<Object?> get props => [status, data, message, selection];
}
