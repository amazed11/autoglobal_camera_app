import 'dart:convert';
import 'dart:io';

import 'package:autoglobal_camera_app/src/features/main/data/models/upload_image/upload_image_request_model.dart';
import 'package:autoglobal_camera_app/src/features/main/domain/usecases/usecase.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/cubit/camera_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../di_injection.dart';
import '../../../../../../core/error/failures.dart';

part 'upload_image_state.dart';

@lazySingleton
class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(const UploadImageState());

  Future<String> convertFileToBase64(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64String = base64Encode(imageBytes);
      return base64String;
    } catch (e) {
      print("Error converting image to base64: $e");
      return '';
    }
  }

  Future<void> uploadImages() async {
    try {
      emit(
        state.copyWith(
          message: "Uploading images, please wait...",
          status: UploadImageStatus.loading,
        ),
      );

      final coverPhoto = getIt<CameraCubit>().state.coverPhotos?.first;
      final exteriorPhotos = getIt<CameraCubit>().state.exteriorPhotos ?? [];
      final interiorPhotos = getIt<CameraCubit>().state.interiorPhotos ?? [];
      final otherPhotos = getIt<CameraCubit>().state.otherPhotos ?? [];

      // Convert images to base64
      String? coverPhotoBase64;
      if (coverPhoto != null) {
        coverPhotoBase64 = await convertFileToBase64(coverPhoto);
      }

      List<String> exteriorPhotosBase64 = [];
      for (var photo in exteriorPhotos) {
        exteriorPhotosBase64.add(await convertFileToBase64(photo));
      }

      List<String> interiorPhotosBase64 = [];
      for (var photo in interiorPhotos) {
        interiorPhotosBase64.add(await convertFileToBase64(photo));
      }

      List<String> otherPhotosBase64 = [];
      for (var photo in otherPhotos) {
        otherPhotosBase64.add(await convertFileToBase64(photo));
      }

      // Construct the payload
      final payload = UploadImageRequestModel(
        coverImage: coverPhotoBase64,
        exteriorImages: exteriorPhotosBase64,
        interiorImages: interiorPhotosBase64,
        otherImages: otherPhotosBase64,
      );

      final response = await getIt<UploadImageUsecase>().call(payload);

      response.fold((failure) {
        emit(
          state.copyWith(
            message: failure.message,
            status: UploadImageStatus.failure,
          ),
        );
      }, (result) {
        emit(
          state.copyWith(
            status: UploadImageStatus.success,
            message: result.message,
          ),
        );
      });
    } on ApiFailure catch (e) {
      emit(
        state.copyWith(
          message: e.message,
          status: UploadImageStatus.failure,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
          status: UploadImageStatus.failure,
        ),
      );
    }
  }
}
