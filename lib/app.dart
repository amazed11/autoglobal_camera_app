import 'package:autoglobal_camera_app/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:autoglobal_camera_app/src/features/auth/presentation/screens/register/cubit/register_cubit.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/cubit/camera_cubit.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/cubit/upload_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme.dart';
import 'di_injection.dart';
import 'src/core/routing/route_generator.dart';
import 'src/features/splash/presentation/cubit/splash_cubit.dart';
import 'src/features/splash/presentation/screens/splash_screen.dart';

class AgCarGeneralApp extends StatelessWidget {
  const AgCarGeneralApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SplashCubit>(),
          child: const SplashScreen(),
        ),
        BlocProvider(
          create: (context) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<RegisterCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CameraCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UploadImageCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: " AG Car General",
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: AppTheme.lightTheme(),
      ),
    );
  }
}
