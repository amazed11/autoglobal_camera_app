part of 'main_cubit.dart';

enum MainStatus { initial, loading, success, loadingMore, failure }

class MainState extends Equatable {
  final MainStatus status;
  final List<CarModel> cars;
  final CarModel? selectedCar;
  final String? message;
  final bool hasMore;
  final int currentPage;
  final int? total;

  const MainState({
    this.status = MainStatus.initial,
    this.cars = const [],
    this.selectedCar,
    this.message,
    this.hasMore = true,
    this.currentPage = 1,
    this.total,
  });

  MainState copyWith({
    MainStatus? status,
    List<CarModel>? cars,
    CarModel? selectedCar,
    String? message,
    bool? hasMore,
    int? currentPage,
    int? total,
    bool clearSelection = false,
  }) {
    return MainState(
      status: status ?? this.status,
      cars: cars ?? this.cars,
      selectedCar: clearSelection ? null : selectedCar ?? this.selectedCar,
      message: message ?? this.message,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [
        status,
        cars,
        selectedCar,
        message,
        hasMore,
        currentPage,
        total,
      ];
}
