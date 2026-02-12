import 'package:autoglobal_camera_app/src/features/main/data/models/upload_image/upload_image_request_model.dart';
import 'package:autoglobal_camera_app/src/models/common_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/configs/api_config.dart';
import '../../../../services/network/api_handler.dart';

abstract class MainRemoteDataSource {
  Future<CommonResponseModel> uploadImages(
      UploadImageRequestModel uploadImageRequestModel);
}

@Injectable(as: MainRemoteDataSource)
class MainRemoteDataSourceImpl implements MainRemoteDataSource {
  final ApiHandler _apiHandler;

  MainRemoteDataSourceImpl(this._apiHandler);

  @override
  Future<CommonResponseModel> uploadImages(
      UploadImageRequestModel uploadImageRequestModel) async {
    try {
      var response = await _apiHandler.post(
        "${ApiConfig.partnerUrl}${ApiConfig.uploadImageUrl}/${uploadImageRequestModel.carId}",
        uploadImageRequestModel.toJson(),
        isauth: true,
      );

      return commonResponseModelFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
