import 'package:bloc/bloc.dart';

class StepCubit extends Cubit<int> {
  StepCubit() : super(0);

  int? _currentStep = 0;
  int? get currentStep => _currentStep;

  void increment() {
    _currentStep = _currentStep! + 1;
    emit(_currentStep!);
  }

  void decrement() {
    if (_currentStep == 0) {
      return;
    }
    _currentStep = _currentStep! - 1;
    emit(_currentStep!);
  }

  void changeStep(int idx) {
    _currentStep = idx;
    emit(idx);
  }

  void reset() {
    _currentStep = 0;
    emit(0);
  }
}
