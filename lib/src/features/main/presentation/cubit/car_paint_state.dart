part of 'car_paint_cubit.dart';

enum CarPaintStatus {
  initial,
  loadingParts,
  partsLoaded,
  submitting,
  submitted,
  failure,
}

class CarPaintState extends Equatable {
  final CarPaintStatus status;
  final CarPaintData? data;
  final String? message;

  /// partKey → single selected option key
  final Map<String, String> selection;

  const CarPaintState({
    this.status = CarPaintStatus.initial,
    this.data,
    this.message,
    this.selection = const {},
  });

  CarPaintState copyWith({
    CarPaintStatus? status,
    CarPaintData? data,
    String? message,
    Map<String, String>? selection,
  }) =>
      CarPaintState(
        status: status ?? this.status,
        data: data ?? this.data,
        message: message ?? this.message,
        selection: selection ?? this.selection,
      );

  /// Number of parts that have a paint option assigned
  int get selectedPartCount => selection.length;

  String? optionFor(String partKey) => selection[partKey];

  bool isPartSelected(String partKey) => selection.containsKey(partKey);

  @override
  List<Object?> get props => [status, data, message, selection];
}
