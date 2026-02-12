// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'src/features/auth/data/datasources/auth_remote_datasource.dart' as _i5;
import 'src/features/auth/data/repositories/auth_repository_impl.dart' as _i7;
import 'src/features/auth/domain/repositories/auth_repository.dart' as _i6;
import 'src/features/auth/domain/usecases/usecase.dart' as _i9;
import 'src/features/auth/presentation/cubit/auth_cubit.dart' as _i4;
import 'src/features/auth/presentation/screens/register/cubit/register_cubit.dart'
    as _i13;
import 'src/features/main/data/datasources/main_remote_datasource.dart' as _i10;
import 'src/features/main/data/repositories/main_repository_impl.dart' as _i12;
import 'src/features/main/domain/repositories/main_repository.dart' as _i11;
import 'src/features/main/domain/usecases/usecase.dart' as _i17;
import 'src/features/main/presentation/screens/components/cubit/camera_cubit.dart'
    as _i8;
import 'src/features/main/presentation/screens/components/cubit/upload_image_cubit.dart'
    as _i16;
import 'src/features/splash/presentation/cubit/splash_cubit.dart' as _i15;
import 'src/services/local/shared_preferences.dart' as _i14;
import 'src/services/network/api_handler.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.ApiHandler>(() => _i3.ApiHandler());
    gh.lazySingleton<_i4.AuthCubit>(() => _i4.AuthCubit());
    gh.factory<_i5.AuthRemoteDataSource>(
        () => _i5.AuthRemoteDataSourceImpl(gh<_i3.ApiHandler>()));
    gh.factory<_i6.AuthRepository>(
        () => _i7.AuthRepositoryImpl(gh<_i5.AuthRemoteDataSource>()));
    gh.lazySingleton<_i8.CameraCubit>(() => _i8.CameraCubit());
    gh.factory<_i9.LoginUsecase>(
        () => _i9.LoginUsecase(gh<_i6.AuthRepository>()));
    gh.factory<_i10.MainRemoteDataSource>(
        () => _i10.MainRemoteDataSourceImpl(gh<_i3.ApiHandler>()));
    gh.factory<_i11.MainRepository>(
        () => _i12.MainRepositoryImpl(gh<_i10.MainRemoteDataSource>()));
    gh.lazySingleton<_i13.RegisterCubit>(() => _i13.RegisterCubit());
    gh.factory<_i9.RegisterUsecase>(
        () => _i9.RegisterUsecase(gh<_i6.AuthRepository>()));
    gh.singleton<_i14.SharedPreference>(() => _i14.SharedPreference());
    gh.lazySingleton<_i15.SplashCubit>(() => _i15.SplashCubit());
    gh.lazySingleton<_i16.UploadImageCubit>(() => _i16.UploadImageCubit());
    gh.factory<_i17.UploadImageUsecase>(
        () => _i17.UploadImageUsecase(gh<_i11.MainRepository>()));
    return this;
  }
}
