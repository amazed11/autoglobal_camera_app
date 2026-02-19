import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/configs/api_config.dart';
import '../../../../services/network/api_handler.dart';
import '../../data/models/car/car_option_model.dart';

part 'car_option_state.dart';

class CarOptionCubit extends Cubit<CarOptionState> {
  final ApiHandler _apiHandler;

  CarOptionCubit(this._apiHandler) : super(const CarOptionState());

  // ── Fetch available options ───────────────────────────────────────────────

  Future<void> fetchOptions() async {
    emit(state.copyWith(status: CarOptionStatus.loading));
    try {
      final response = await _apiHandler.post(ApiConfig.carsOptionsJsonUrl, {},
          isauth: true);
      final model = carOptionsResponseFromJson(response.toString());
      emit(state.copyWith(
        status: CarOptionStatus.loaded,
        options: model.data,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CarOptionStatus.failure,
        message: e.toString(),
      ));
    }
  }

  // ── Local selection ───────────────────────────────────────────────────────

  void toggleOption(int id) {
    final updated = Set<int>.from(state.selectedIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    emit(state.copyWith(selectedIds: updated));
  }

  void selectAll() => emit(state.copyWith(
      selectedIds: Set<int>.from(state.options.map((o) => o.id))));

  void clearAll() => emit(state.copyWith(selectedIds: {}));

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> submitOptions(int carId) async {
    if (state.selectedIds.isEmpty) return;
    emit(state.copyWith(status: CarOptionStatus.submitting));
    try {
      await _apiHandler.post(
        '${ApiConfig.carsOptionsUrl}/$carId',
        {'car_options': state.selectedIds.toList()},
        isauth: true,
      );
      emit(state.copyWith(
        status: CarOptionStatus.submitted,
        message: 'Car options updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CarOptionStatus.failure,
        message: e.toString(),
      ));
    }
  }
}
