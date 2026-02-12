part of 'camera_cubit.dart';

class CameraState extends Equatable {
  final bool? coverPhotoValid;
  final bool? exteriorPhotosValid;
  final bool? interiorPhotosValid;
  final bool? otherPhotosValid;
  final bool? videoValid;

  List<File>? coverPhotos;
  List<File>? exteriorPhotos;
  List<File>? interiorPhotos;
  List<File>? otherPhotos;
  List<File>? videos;

  CameraState({
    this.coverPhotos,
    this.exteriorPhotos,
    this.interiorPhotos,
    this.otherPhotos,
    this.coverPhotoValid = false,
    this.exteriorPhotosValid = false,
    this.interiorPhotosValid = false,
    this.otherPhotosValid = false,
    this.videoValid = false,
    this.videos,
  });
  CameraState copyWith({
    List<File>? coverPhotos,
    List<File>? exteriorPhotos,
    List<File>? interiorPhotos,
    List<File>? otherPhotos,
    bool? coverPhotoValid,
    bool? exteriorPhotosValid,
    bool? interiorPhotosValid,
    bool? otherPhotosValid,
    List<File>? videos,
    bool? videoValid,
  }) {
    return CameraState(
      coverPhotos: coverPhotos ?? this.coverPhotos,
      exteriorPhotos: exteriorPhotos ?? this.exteriorPhotos,
      interiorPhotos: interiorPhotos ?? this.interiorPhotos,
      otherPhotos: otherPhotos ?? this.otherPhotos,
      coverPhotoValid: coverPhotoValid ?? this.coverPhotoValid,
      exteriorPhotosValid: exteriorPhotosValid ?? this.exteriorPhotosValid,
      interiorPhotosValid: interiorPhotosValid ?? this.interiorPhotosValid,
      otherPhotosValid: otherPhotosValid ?? this.otherPhotosValid,
      videos: videos ?? this.videos,
      videoValid: videoValid ?? this.videoValid,
    );
  }

  @override
  List<Object?> get props => [
        coverPhotoValid,
        exteriorPhotosValid,
        interiorPhotosValid,
        otherPhotosValid,
        coverPhotos,
        exteriorPhotos,
        interiorPhotos,
        otherPhotos,
        videos,
        videoValid,
      ];
}
