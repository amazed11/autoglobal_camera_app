import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/configs/api_config.dart';
import '../../../../services/network/api_handler.dart';
import '../../data/models/car/car_paint_model.dart';

part 'car_paint_state.dart';

class CarPaintCubit extends Cubit<CarPaintState> {
  final ApiHandler _apiHandler;

  CarPaintCubit(this._apiHandler) : super(const CarPaintState());

  // ── Fetch paint parts & options ───────────────────────────────────────────

  Future<void> fetchParts() async {
    emit(state.copyWith(status: CarPaintStatus.loadingParts));
    try {
      final response =
          await _apiHandler.post(ApiConfig.carsPaintJsonUrl, {}, isauth: true);
      final model = carPaintPartsModelFromJson(response.toString());
      emit(state.copyWith(
        status: CarPaintStatus.partsLoaded,
        data: model.data,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CarPaintStatus.failure,
        message: e.toString(),
      ));
    }
  }

  // ── Local selection management ────────────────────────────────────────────

  /// Set (or replace) the single paint option for a part.
  void setOption(String partKey, String optionKey) {
    final updated = Map<String, String>.from(state.selection);
    updated[partKey] = optionKey;
    emit(state.copyWith(selection: updated));
  }

  /// Remove the selection for a part.
  void clearPart(String partKey) {
    final updated = Map<String, String>.from(state.selection)..remove(partKey);
    emit(state.copyWith(selection: updated));
  }

  void clearAll() => emit(state.copyWith(selection: {}));

  // ── Submit paint report ───────────────────────────────────────────────────

  Future<void> submitReport(int carId) async {
    if (state.selection.isEmpty) return;
    emit(state.copyWith(status: CarPaintStatus.submitting));
    try {
      // Body: { "hood": "original_paint", "trunk": "repainted", … }
      final body = Map<String, dynamic>.from(state.selection);
      await _apiHandler.post(
        '${ApiConfig.carsPaintUrl}/$carId',
        body,
        isauth: true,
      );
      emit(state.copyWith(
        status: CarPaintStatus.submitted,
        message: 'Car part paint updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CarPaintStatus.failure,
        message: e.toString(),
      ));
    }
  }
}
