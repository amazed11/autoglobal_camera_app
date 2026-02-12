import 'package:autoglobal_camera_app/src/features/main/data/models/upload_image/upload_image_request_model.dart';
import 'package:autoglobal_camera_app/src/models/common_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/api_exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/main_repository.dart';
import '../datasources/main_remote_datasource.dart';

@Injectable(as: MainRepository)
class MainRepositoryImpl implements MainRepository {
  final MainRemoteDataSource _authRemoteDataSource;

  MainRepositoryImpl(this._authRemoteDataSource);
  @override
  Future<Either<Failure, CommonResponseModel>> uploadImages(
      UploadImageRequestModel uploadImageRequestModel) async {
    // TODO: implement login
    try {
      final response =
          await _authRemoteDataSource.uploadImages(uploadImageRequestModel);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.message.toString()));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }
}
