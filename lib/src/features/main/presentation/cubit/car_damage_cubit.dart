import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/configs/api_config.dart';
import '../../../../services/network/api_handler.dart';
import '../../data/models/car/car_damage_model.dart';

part 'car_damage_state.dart';

class CarDamageCubit extends Cubit<CarDamageState> {
  final ApiHandler _apiHandler;

  CarDamageCubit(this._apiHandler) : super(const CarDamageState());

  // ──────────────────────────────────────────────
  // Fetch damage parts & options
  // ──────────────────────────────────────────────

  Future<void> fetchParts() async {
    emit(state.copyWith(status: CarDamageStatus.loadingParts));
    try {
      final response =
          await _apiHandler.get(ApiConfig.carsDamageJsonUrl, isauth: true);
      final model = carDamagePartsModelFromJson(response.toString());
      emit(state.copyWith(
        status: CarDamageStatus.partsLoaded,
        data: model.data,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CarDamageStatus.failure,
        message: e.toString(),
      ));
    }
  }

  // ──────────────────────────────────────────────
  // Local selection management
  // ──────────────────────────────────────────────

  /// Toggle an option for a given part.
  void toggleOption(String partKey, String optionKey) {
    final current = Map<String, Set<String>>.from(
      state.selection.map((k, v) => MapEntry(k, Set<String>.from(v))),
    );
    final partSet = current.putIfAbsent(partKey, () => {});
    if (partSet.contains(optionKey)) {
      partSet.remove(optionKey);
      if (partSet.isEmpty) current.remove(partKey);
    } else {
      partSet.add(optionKey);
    }
    emit(state.copyWith(selection: current));
  }

  /// Remove all options for a part.
  void clearPart(String partKey) {
    final current = Map<String, Set<String>>.from(
      state.selection.map((k, v) => MapEntry(k, Set<String>.from(v))),
    );
    current.remove(partKey);
    emit(state.copyWith(selection: current));
  }

  void clearAll() => emit(state.copyWith(selection: {}));

  bool isOptionSelected(String partKey, String optionKey) =>
      state.selection[partKey]?.contains(optionKey) ?? false;

  bool isPartSelected(String partKey) =>
      (state.selection[partKey]?.isNotEmpty) ?? false;

  // ──────────────────────────────────────────────
  // Submit damage report
  // ──────────────────────────────────────────────

  Future<void> submitReport(int carId) async {
    if (state.selection.isEmpty) return;
    emit(state.copyWith(status: CarDamageStatus.submitting));
    try {
      final body =
          damageSelectionToJson(state.selection).map((k, v) => MapEntry(k, v));
      await _apiHandler.post(
        '${ApiConfig.carsDamageUrl}/$carId',
        body,
        isauth: true,
      );
      emit(state.copyWith(
          status: CarDamageStatus.submitted,
          message: 'Car part conditions updated successfully'));
    } catch (e) {
      emit(state.copyWith(
        status: CarDamageStatus.failure,
        message: e.toString(),
      ));
    }
  }
}
