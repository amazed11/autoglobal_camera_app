import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/configs/api_config.dart';
import '../../../../services/network/api_handler.dart';
import '../../data/models/car/car_response_model.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final ApiHandler _apiHandler;

  MainCubit(this._apiHandler) : super(const MainState());

  Future<void> fetchInitialCars() async {
    emit(
      state.copyWith(
        status: MainStatus.loading,
        clearSelection: true,
        cars: [],
        currentPage: 1,
        hasMore: true,
      ),
    );
    await _fetchCars(page: 1);
  }

  Future<void> fetchMoreCars() async {
    if (state.status == MainStatus.loadingMore || !state.hasMore) {
      return;
    }

    emit(state.copyWith(status: MainStatus.loadingMore));
    await _fetchCars(page: state.currentPage + 1);
  }

  Future<void> _fetchCars({required int page}) async {
    try {
      final response = await _apiHandler.get(
        '${ApiConfig.cameraCarsUrl}?page=$page',
        isauth: true,
      );

      final model = carResponseModelFromJson(response.toString());
      final allCars = page == 1 ? model.data : [...state.cars, ...model.data];
      final sampleCar = CarModel(
        id: 1,
        image: 'http://example.com/storage/images/xxx.png?cachekey',
        dbClassification: 'SAUDI ARABIA',
        chasissNumber: 'ABC123',
        carManufacturer: 'Toyota',
        model: 'Camry',
        carLabel: 'Premium',
        year: 2020,
        exteriorColor: 'Black',
        interiorColor: 'Beige',
        fuelType: 'Gasoline',
        transmissionType: 'Automatic',
        city: 'Riyadh',
        carNumber: 'CAR-101',
        mileage: '50000',
        source: 'Auction',
        favorite: false,
      );
      emit(
        state.copyWith(
          status: MainStatus.success,
          cars: [sampleCar, ...allCars],
          selectedCar:
              allCars.isEmpty ? null : state.selectedCar ?? allCars.first,
          hasMore: model.hasMore,
          currentPage: page,
          total: model.total,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MainStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  void selectCar(CarModel car) {
    emit(state.copyWith(selectedCar: car));
  }
}
