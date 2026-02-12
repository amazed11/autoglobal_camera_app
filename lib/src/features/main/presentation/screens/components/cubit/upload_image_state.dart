part of 'upload_image_cubit.dart';

enum UploadImageStatus { initial, loading, success, failure }

class UploadImageState extends Equatable {
  final UploadImageStatus status;
  final String? message;

  const UploadImageState({
    this.status = UploadImageStatus.initial,
    this.message,
  });

  UploadImageState copyWith({
    UploadImageStatus? status,
    String? message,
  }) {
    return UploadImageState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
      ];
}
