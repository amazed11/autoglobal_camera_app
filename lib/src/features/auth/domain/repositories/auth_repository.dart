import 'package:autoglobal_camera_app/src/features/auth/data/models/login/login_response_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/login/login_request_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseModel>> login(
      LoginRequestModel loginRequestModel);
}
