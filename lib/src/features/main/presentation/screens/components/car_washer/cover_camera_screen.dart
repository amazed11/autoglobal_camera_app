import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:autoglobal_camera_app/di_injection.dart';
import 'package:autoglobal_camera_app/src/core/app/dimensions.dart';
import 'package:autoglobal_camera_app/src/core/enums/enums.dart';
import 'package:autoglobal_camera_app/src/utils/custom_toasts.dart';
import 'package:autoglobal_camera_app/src/widgets/custom_dialogs.dart';
import 'package:autoglobal_camera_app/src/widgets/custom_text.dart';
import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../../../../core/states/states.dart';
import '../cubit/camera_cubit.dart';
import 'cover_api.dart';

class CoverCameraScreen extends StatefulWidget {
  const CoverCameraScreen({super.key});

  @override
  State<CoverCameraScreen> createState() => CoverCameraScreenState();
}

class CoverCameraScreenState extends State<CoverCameraScreen> {
  CameraOrientation _orientation = CameraOrientation.portraitUp;

  late CameraController cameraController;
  late Future<void> cameraValue;
  List<File> imagesList = [];
  bool isFlashOn = false;
  bool isRearCamera = true;

  Future<File> saveImage(XFile image) async {
    final downlaodPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('$downlaodPath/$fileName');

    try {
      await file.writeAsBytes(await image.readAsBytes());
    } catch (_) {}

    return file;
  }

  void takePicture() async {
    XFile? image;

    if (cameraController.value.isTakingPicture ||
        !cameraController.value.isInitialized) {
      return;
    }

    if (isFlashOn == false) {
      await cameraController.setFlashMode(FlashMode.off);
    } else {
      await cameraController.setFlashMode(FlashMode.torch);
    }
    image = await cameraController.takePicture();

    if (cameraController.value.flashMode == FlashMode.torch) {
      setState(() {
        cameraController.setFlashMode(FlashMode.off);
      });
    }

    final data =
        await GoogleVisionService().detectLabels(File(image.path), context);

    if (data) {
      final file = await saveImage(image);
      setState(() {
        imagesList.clear();
        imagesList.add(file);
      });
      MediaScanner.loadMedia(path: file.path);
    }
  }

  void startCamera(int camera) {
    cameraController = CameraController(
      cameras[camera],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraValue = cameraController.initialize();
  }

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  // StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  double azimuth = 0.0;

  @override
  void initState() {
    startCamera(0);
    // initTFLite();

    _accelerometerSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      setState(() {
        if (event.x.abs() > event.y.abs()) {
          if (event.x > 0) {
            _orientation = CameraOrientation.landscapeLeft;
          } else {
            _orientation = CameraOrientation.landscapeRight;
          }
        } else {
          if (event.y > 0) {
            _orientation = CameraOrientation.portraitUp;
          } else {
            _orientation = CameraOrientation.portraitDown;
          }
        }
      });

      // _magnetometerSubscription =
      //     magnetometerEventStream().listen((MagnetometerEvent event) {
      //   setState(() {
      //     x = event.x;
      //     y = event.y;
      //     z = event.z;
      //   });
      // });
    });
    super.initState();
  }

  double calculateAzimuth(double x, double y) {
    double angle = math.atan2(y, x) * (180 / math.pi);
    if (angle < 0) {
      angle += 360; // Normalize to 0-360 degrees
    }
    return angle;
  }

  String getDirection(double azimuth) {
    if (azimuth >= 135 && azimuth <= 225) {
      return "South";
    } else if (azimuth > 225 && azimuth < 315) {
      return "West";
    } else if (azimuth >= 315 || azimuth <= 45) {
      return "North";
    } else if (azimuth > 45 && azimuth < 135) {
      return "East";
    }
    return "Unknown";
  }

  bool isCarFound = false;

  // void getImageLabels(File image) async {
  //   try {
  //     print("-------------");

  //     final inputImage = InputImage.fromFilePath(image.path);
  //     ImageLabeler imageLabeler = ImageLabeler(
  //         options: const ImageLabelerOptions(confidenceThreshold: 0.75));
  //     List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

  //     for (ImageLabel imgLabel in labels) {
  //       String lblText = imgLabel.label;
  //       double confidence = imgLabel.confidence;
  //       print(lblText);
  //       print(confidence);
  //     }
  //     if (labels.isEmpty) {
  //       showNoCarDialog();
  //     }
  //     for (var element in labels) {
  //       if (element.label.toLowerCase() == "car") {
  //         isCarFound = true;
  //         setState(() {});
  //       }
  //     }

  //     if (isCarFound) {
  //       final file = await saveImage(XFile(image.path));
  //       setState(() {
  //         imagesList.clear();
  //         imagesList.add(file);
  //       });
  //       MediaScanner.loadMedia(path: file.path);
  //     } else {
  //       showNoCarDialog();
  //     }
  //     imageLabeler.close();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  void dispose() {
    cameraController.dispose();
    _accelerometerSubscription?.cancel();
    // _magnetometerSubscription?.cancel();
    // Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // String direction = getDirection(azimuth);
    // bool isSoutheast = direction == "East" && azimuth > 90 && azimuth < 135;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(255, 255, 255, .7),
        shape: const CircleBorder(),
        onPressed: () {
          if (_orientation == CameraOrientation.portraitDown ||
              _orientation == CameraOrientation.portraitUp) {
            warningToast(msg: "Please click picture in landscape mode");
            return;
          }
          takePicture();
        },
        child: const Icon(
          Icons.camera_alt,
          size: 40,
          color: Colors.black87,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Center(
                      child: SizedBox(
                        width: 100,
                        child: CameraPreview(cameraController),
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: Container(
                padding: screenPadding,
                margin: screenPadding,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomText.ourText(
                  "Cover Picture Session",
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 5, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (imagesList.isNotEmpty) {
                          getIt<CameraCubit>().addCoverPhotos(imagesList);
                          context.pop();
                        } else {
                          errorToast(msg: "Please take a picture");
                        }
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.done_rounded,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    vSizedBox2,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFlashOn = !isFlashOn;
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(50, 0, 0, 0),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: isFlashOn
                              ? const Icon(
                                  Icons.flash_on,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.flash_off,
                                  color: Colors.white,
                                  size: 30,
                                ),
                        ),
                      ),
                    ),
                    vSizedBox2,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isRearCamera = !isRearCamera;
                        });
                        isRearCamera ? startCamera(0) : startCamera(1);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(50, 0, 0, 0),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: isRearCamera
                              ? const Icon(
                                  Icons.camera_rear,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.camera_front,
                                  color: Colors.white,
                                  size: 30,
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7, bottom: 75),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: imagesList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () => CustomDialogs.showImageDialog(
                              context: context,
                              imageUrl: imagesList[index].path,
                              isLocal: true,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      height: 100,
                                      width: 100,
                                      opacity: const AlwaysStoppedAnimation(07),
                                      image: FileImage(
                                        File(imagesList[index].path),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          imagesList.remove(imagesList[index]);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.cancel,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
