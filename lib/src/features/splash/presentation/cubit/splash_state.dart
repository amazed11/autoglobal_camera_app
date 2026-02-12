part of 'splash_cubit.dart';

enum SplashStatus {
  initial,
  loggedIn,
  loggedOut,
  appUpdate,
  appFirstTime,
}

class SplashState extends Equatable {
  final SplashStatus? status;
  final String? message;
  const SplashState({
    this.status,
    this.message,
  });
  SplashState copyWith({
    SplashStatus? status,
    String? message,
  }) {
    return SplashState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
  @override
  String toString() {
    return '''Splash State { status: $status, message: $message }''';
  }
}
