import 'package:autoglobal_camera_app/src/features/auth/data/models/login/login_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/login/login_request_model.dart';
import '../../data/models/register/register_request_model.dart';
import '../../data/models/register/register_response_model.dart';
import '../repositories/auth_repository.dart';

part 'login_usecase.dart';
part 'register_usecase.dart';
