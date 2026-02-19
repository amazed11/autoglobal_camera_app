import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/configs/api_config.dart';
import '../../../../services/network/api_handler.dart';
import '../../data/models/car/car_permission_model.dart';

part 'car_permission_state.dart';

class CarPermissionCubit extends Cubit<CarPermissionState> {
  final ApiHandler _apiHandler;

  CarPermissionCubit(this._apiHandler) : super(const CarPermissionState());

  Future<void> fetchPermission(int carId) async {
    emit(state.copyWith(status: CarPermissionStatus.loading));
    try {
      final response = await _apiHandler.get(
        '${ApiConfig.cameraCarsUrl}/$carId',
        isauth: true,
      );
      final model = carPermissionModelFromJson(response.toString());
      emit(state.copyWith(
        status: CarPermissionStatus.success,
        data: model.data,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CarPermissionStatus.failure,
        message: e.toString(),
      ));
    }
  }
}
