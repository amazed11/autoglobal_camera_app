// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'src/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i856;
import 'src/features/auth/data/repositories/auth_repository_impl.dart' as _i423;
import 'src/features/auth/domain/repositories/auth_repository.dart' as _i546;
import 'src/features/auth/domain/usecases/usecase.dart' as _i548;
import 'src/features/auth/presentation/cubit/auth_cubit.dart' as _i25;
import 'src/features/main/data/datasources/main_remote_datasource.dart'
    as _i313;
import 'src/features/main/data/repositories/main_repository_impl.dart' as _i416;
import 'src/features/main/domain/repositories/main_repository.dart' as _i968;
import 'src/features/main/domain/usecases/usecase.dart' as _i609;
import 'src/features/main/presentation/screens/components/cubit/camera_cubit.dart'
    as _i884;
import 'src/features/main/presentation/screens/components/cubit/upload_image_cubit.dart'
    as _i208;
import 'src/features/splash/presentation/cubit/splash_cubit.dart' as _i401;
import 'src/services/local/shared_preferences.dart' as _i431;
import 'src/services/network/api_handler.dart' as _i423;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i431.SharedPreference>(() => _i431.SharedPreference());
    gh.singleton<_i423.ApiHandler>(() => _i423.ApiHandler());
    gh.lazySingleton<_i25.AuthCubit>(() => _i25.AuthCubit());
    gh.lazySingleton<_i884.CameraCubit>(() => _i884.CameraCubit());
    gh.lazySingleton<_i208.UploadImageCubit>(() => _i208.UploadImageCubit());
    gh.lazySingleton<_i401.SplashCubit>(() => _i401.SplashCubit());
    gh.factory<_i856.AuthRemoteDataSource>(
        () => _i856.AuthRemoteDataSourceImpl(gh<_i423.ApiHandler>()));
    gh.factory<_i313.MainRemoteDataSource>(
        () => _i313.MainRemoteDataSourceImpl(gh<_i423.ApiHandler>()));
    gh.factory<_i546.AuthRepository>(
        () => _i423.AuthRepositoryImpl(gh<_i856.AuthRemoteDataSource>()));
    gh.factory<_i548.LoginUsecase>(
        () => _i548.LoginUsecase(gh<_i546.AuthRepository>()));
    gh.factory<_i968.MainRepository>(
        () => _i416.MainRepositoryImpl(gh<_i313.MainRemoteDataSource>()));
    gh.factory<_i609.UploadImageUsecase>(
        () => _i609.UploadImageUsecase(gh<_i968.MainRepository>()));
    return this;
  }
}
