import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//global scaffold key
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

GlobalKey<ScaffoldState> tabBarKey = GlobalKey();

// List<CountryModel> countryModelData = <CountryModel>[];

ValueNotifier<bool> showPassswordVisibility = ValueNotifier<bool>(true);
ValueNotifier<Uint8List?> editedImage = ValueNotifier<Uint8List?>(null);

//make,model,release,label,option,origin
final GlobalKey<ScaffoldState> makeDrawerKey = GlobalKey();
final GlobalKey<ScaffoldState> modelDrawerKey = GlobalKey();
final GlobalKey<ScaffoldState> releaseDrawerKey = GlobalKey();
final GlobalKey<ScaffoldState> labelDrawerKey = GlobalKey();
final GlobalKey<ScaffoldState> optionDrawerKey = GlobalKey();
final GlobalKey<ScaffoldState> originDrawerKey = GlobalKey();
final GlobalKey<ScaffoldState> filterDrawerKey = GlobalKey();

ValueNotifier<int> duration = ValueNotifier<int>(60);
Timer? otpResendTimer;
String defaultLanguageCode = 'en';
List<CameraDescription> cameras = [];
