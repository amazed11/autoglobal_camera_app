import 'package:autoglobal_camera_app/src/features/main/data/models/upload_image/upload_image_request_model.dart';
import 'package:autoglobal_camera_app/src/models/common_response_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class MainRepository {
  Future<Either<Failure, CommonResponseModel>> uploadImages(
      UploadImageRequestModel uploadImageRequestModel);
}
