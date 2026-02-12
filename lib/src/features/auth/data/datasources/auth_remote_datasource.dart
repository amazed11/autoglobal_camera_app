import 'package:autoglobal_camera_app/src/features/auth/data/models/login/login_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/configs/api_config.dart';
import '../../../../services/network/api_handler.dart';
import '../models/login/login_request_model.dart';
import '../models/register/register_request_model.dart';
import '../models/register/register_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel);

  Future<RegisterResponseModel> register(
      RegisterRequestModel registerRequestModel);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiHandler _apiHandler;

  AuthRemoteDataSourceImpl(this._apiHandler);

  @override
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    try {
      var response = await _apiHandler.post(
        ApiConfig.loginUrl,
        loginRequestModel.toJson(),
      );

      return loginResponseModelFromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RegisterResponseModel> register(
      RegisterRequestModel registerRequestModel) async {
    // TODO: implement register
    try {
      var response = await _apiHandler.post(
        ApiConfig.partnerUrl + ApiConfig.authUrl + ApiConfig.registerUrl,
        registerRequestModel.toJson(),
      );
      return registerResponseModelFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
