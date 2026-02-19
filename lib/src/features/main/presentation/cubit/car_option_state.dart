part of 'car_option_cubit.dart';

enum CarOptionStatus {
  initial,
  loading,
  loaded,
  submitting,
  submitted,
  failure
}

class CarOptionState extends Equatable {
  final CarOptionStatus status;
  final List<CarOption> options;
  final Set<int> selectedIds;
  final String? message;

  const CarOptionState({
    this.status = CarOptionStatus.initial,
    this.options = const [],
    this.selectedIds = const {},
    this.message,
  });

  bool isSelected(int id) => selectedIds.contains(id);

  CarOptionState copyWith({
    CarOptionStatus? status,
    List<CarOption>? options,
    Set<int>? selectedIds,
    String? message,
  }) =>
      CarOptionState(
        status: status ?? this.status,
        options: options ?? this.options,
        selectedIds: selectedIds ?? this.selectedIds,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props => [status, options, selectedIds, message];
}
