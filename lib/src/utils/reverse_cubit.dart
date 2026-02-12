import 'package:bloc/bloc.dart';

class ReverseCubit extends Cubit<bool> {
  ReverseCubit() : super(false);

  bool _isfocused = false;
  bool get isFocused => _isfocused;

  void setFoucs(bool hasFocus) {
    _isfocused = hasFocus;
    emit(hasFocus);
  }

  void setTrue() {
    _isfocused = true;
    emit(true);
  }

  void setFalse() {
    _isfocused = false;
    emit(false);
  }
}
