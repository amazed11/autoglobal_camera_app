import 'package:autoglobal_camera_app/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:autoglobal_camera_app/src/features/auth/presentation/screens/register/register_screen.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/car_tester/car_tester_screen.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/car_washer/all_car_image_screen.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/car_washer/car_washer_screen.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/car_washer/cover_camera_screen.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/car_washer/exterior_camera_screen.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/car_washer/interior_camera_screen.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/car_washer/other_camera_screen.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/car_washer/re_order_images_screen.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/main/presentation/screens/components/car_washer/video_session_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../configs/route_config.dart';

class AppRouter {
  GoRouter? globalGoRouter;

  GoRouter getGoRouter() {
    return globalGoRouter ??= router;
  }

  void clearAndNavigate(String path) {
    while (getGoRouter().canPop() == true) {
      getGoRouter().pop();
    }
    getGoRouter().pushReplacementNamed(path);
  }

  static final GoRouter router = GoRouter(
    initialLocation: RouteConfig.splashRoute,
    routes: <RouteBase>[
      GoRoute(
        name: RouteConfig.splashRoute,
        path: RouteConfig.splashRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.loginRoute,
        path: RouteConfig.loginRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.registerRoute,
        path: RouteConfig.registerRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.mainRoute,
        path: RouteConfig.mainRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const MainScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.carWasherRoute,
        path: RouteConfig.carWasherRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const CarWasherScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.coverImageRoute,
        path: RouteConfig.coverImageRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const CoverCameraScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.allImageRoute,
        path: RouteConfig.allImageRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const AllCarImageScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.carTesterRoute,
        path: RouteConfig.carTesterRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const CarTesterScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.exteriorImageRoute,
        path: RouteConfig.exteriorImageRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const ExteriorCameraScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.interiorImageRoute,
        path: RouteConfig.interiorImageRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const InteriorCameraScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.otherImageRoute,
        path: RouteConfig.otherImageRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const OtherCameraScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.videoRoute,
        path: RouteConfig.videoRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const VideoSessionScreen();
        },
      ),
      GoRoute(
        name: RouteConfig.reOrderImageRoute,
        path: RouteConfig.reOrderImageRoute,
        builder: (BuildContext context, GoRouterState state) {
          ReorderImageModel data = state.extra as ReorderImageModel;
          return ReorderImageScreen(
            reorderImageModel: data,
          );
        },
      ),
    ],
  );
}
