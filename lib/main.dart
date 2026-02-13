import 'package:autoglobal_camera_app/src/core/states/states.dart';
import 'package:autoglobal_camera_app/src/services/local/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'app_bloc_observer.dart';
import 'di_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  configureDependenciesInjection();
  Bloc.observer = AppBlocObserver();
  await SharedPreference.sharedPrefInit();
  cameras = await availableCameras();
  print("Total camera available: ${cameras.length}");
  runApp(const AgCarGeneralApp());
}
