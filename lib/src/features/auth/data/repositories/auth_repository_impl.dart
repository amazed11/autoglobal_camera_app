import 'package:autoglobal_camera_app/src/features/auth/data/models/login/login_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/api_exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login/login_request_model.dart';
import '../models/register/register_request_model.dart';
import '../models/register/register_response_model.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);
  @override
  Future<Either<Failure, LoginResponseModel>> login(
      LoginRequestModel loginRequestModel) async {
    // TODO: implement login
    try {
      final response = await _authRemoteDataSource.login(loginRequestModel);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.message.toString()));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RegisterResponseModel>> register(
      RegisterRequestModel registerRequestModel) async {
    // TODO: implement register
    try {
      final response =
          await _authRemoteDataSource.register(registerRequestModel);
      return Right(response);
    } on ApiException catch (e) {
      return Left(ApiFailure(e.message.toString()));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }
}
