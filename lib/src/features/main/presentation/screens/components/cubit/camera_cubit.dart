import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'camera_state.dart';

@lazySingleton
class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraState());

  void addCoverPhotos(List<File>? files) {
    if (files?.isNotEmpty ?? false) {
      List<File> updatedPhotos = List<File>.from(state.coverPhotos ?? []);
      updatedPhotos.clear();
      updatedPhotos.addAll(files ?? []);
      emit(
        state.copyWith(
          coverPhotoValid: updatedPhotos.isNotEmpty,
          coverPhotos: updatedPhotos,
        ),
      );
    }
  }

  void addExteriorPhotos(List<File>? files) {
    if (files?.isNotEmpty ?? false) {
      List<File> updatedPhotos = List<File>.from(state.exteriorPhotos ?? []);
      updatedPhotos.addAll(files ?? []);
      emit(
        state.copyWith(
          exteriorPhotosValid:
              updatedPhotos.length >= 4 && updatedPhotos.length <= 6,
          exteriorPhotos: updatedPhotos,
        ),
      );
    }
  }

  void addInteriorPhotos(List<File>? files) {
    if (files?.isNotEmpty ?? false) {
      List<File> updatedPhotos = List<File>.from(state.interiorPhotos ?? []);
      updatedPhotos.addAll(files ?? []);
      emit(
        state.copyWith(
          interiorPhotosValid:
              updatedPhotos.length >= 6 && updatedPhotos.length <= 10,
          interiorPhotos: updatedPhotos,
        ),
      );
    }
  }

  void addVideo(File? file) {
    if (file != null) {
      List<File> updatedVideos = List<File>.from(state.videos ?? []);
      updatedVideos.add(file);
      emit(
        state.copyWith(
          videoValid: updatedVideos.isNotEmpty,
          videos: updatedVideos,
        ),
      );
    }
  }

  void addOtherPhotos(List<File>? files) {
    if (files?.isNotEmpty ?? false) {
      List<File> updatedPhotos = List<File>.from(state.otherPhotos ?? []);
      updatedPhotos.addAll(files ?? []);
      emit(
        state.copyWith(
          otherPhotosValid: (updatedPhotos.length) <= 5,
          otherPhotos: updatedPhotos,
        ),
      );
    }
  }

  void removeCoverPhoto(File file) {
    // Get the current list of exterior photos from the state
    List<File>? images = List<File>.from(state.coverPhotos ?? []);

    // If the list is empty or null, return early
    if (images.isEmpty) return;

    // Remove the specified file from the list
    images.remove(file);

    // Emit the new state with updated properties
    emit(state.copyWith(
      coverPhotos: images,
      coverPhotoValid: images.isNotEmpty,
    ));
  }

  void removeExteriorPhoto(File file) {
    List<File>? images = List<File>.from(state.exteriorPhotos ?? []);

    if (images.isEmpty) return;

    images.remove(file);

    emit(state.copyWith(
      exteriorPhotos: images,
      exteriorPhotosValid: images.length == 4 || images.length == 6,
    ));
  }

  void removeInteriorPhoto(File file) {
    List<File>? images = List<File>.from(state.interiorPhotos ?? []);

    if (images.isEmpty) return;

    images.remove(file);

    emit(state.copyWith(
      interiorPhotos: images,
      interiorPhotosValid: images.length >= 8 && images.length <= 10,
    ));
  }

  void removeOtherPhoto(File file) {
    List<File>? images = List<File>.from(state.otherPhotos ?? []);

    if (images.isEmpty) return;

    images.remove(file);

    emit(state.copyWith(
      otherPhotos: images,
      otherPhotosValid: images.length <= 5,
    ));
  }

  void removeVideo(File file) {
    List<File>? videos = List<File>.from(state.videos ?? []);

    if (videos.isEmpty) return;

    videos.remove(file);

    emit(state.copyWith(
      videos: videos,
      videoValid: videos.isNotEmpty,
    ));
  }

  void removeAll() {
    List<File>? coverPhotos = List<File>.from(state.coverPhotos ?? []);
    List<File>? exteriorPhotos = List<File>.from(state.exteriorPhotos ?? []);

    List<File>? interiorPhotos = List<File>.from(state.interiorPhotos ?? []);

    List<File>? otherPhotos = List<File>.from(state.otherPhotos ?? []);
    coverPhotos.clear();
    exteriorPhotos.clear();
    interiorPhotos.clear();
    otherPhotos.clear();

    emit(state.copyWith(
      coverPhotos: coverPhotos,
      interiorPhotos: interiorPhotos,
      exteriorPhotos: exteriorPhotos,
      otherPhotos: otherPhotos,
      coverPhotoValid: coverPhotos.isNotEmpty,
      exteriorPhotosValid: exteriorPhotos.isNotEmpty,
      interiorPhotosValid: interiorPhotos.isNotEmpty,
      otherPhotosValid: otherPhotos.isNotEmpty,
    ));
  }
}
