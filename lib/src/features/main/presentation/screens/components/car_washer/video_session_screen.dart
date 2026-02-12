import 'dart:async';
import 'dart:io';

import 'package:autoglobal_camera_app/di_injection.dart';
import 'package:autoglobal_camera_app/src/core/app/dimensions.dart';
import 'package:autoglobal_camera_app/src/utils/custom_toasts.dart';
import 'package:autoglobal_camera_app/src/widgets/custom_dialogs.dart';
import 'package:autoglobal_camera_app/src/widgets/custom_text.dart';
import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/states/states.dart';
import '../cubit/camera_cubit.dart';

class VideoSessionScreen extends StatefulWidget {
  const VideoSessionScreen({super.key});

  @override
  State<VideoSessionScreen> createState() => VideoSessionScreenState();
}

class VideoSessionScreenState extends State<VideoSessionScreen> {
  late CameraController cameraController;
  late Future<void> cameraValue;
  List<File> imagesList = [];
  File? videoFile;
  bool isFlashOn = false;
  bool isRearCamera = true;
  bool isRecording = false;
  Timer? timer;
  Timer? recordingTimer;
  Duration recordingDuration = Duration.zero;
  VideoPlayerController? videoPlayerController;
  Future<void>? initializeVideoPlayerFuture;

  Future<File> saveImage(XFile image) async {
    final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('$downloadPath/$fileName');

    try {
      await file.writeAsBytes(await image.readAsBytes());
    } catch (_) {}

    return file;
  }

  Future<File> saveVideo(XFile video) async {
    final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
    final file = File('$downloadPath/$fileName');

    try {
      await file.writeAsBytes(await video.readAsBytes());
    } catch (_) {}

    return file;
  }

  bool isCarFound = false;

  void takePicture() async {
    if (getIt<CameraCubit>().state.videos?.isNotEmpty ?? true) {
      errorToast(msg: "You reached the limit for maximum videos i.e. 1/1");
      return;
    }
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

    final file = await saveImage(image);
    setState(() {
      imagesList.add(file);
      MediaScanner.loadMedia(path: file.path);
    });
  }

  void startCamera(int camera) {
    cameraController = CameraController(
      cameras[camera],
      ResolutionPreset.high,
      enableAudio: true,
    );
    cameraValue = cameraController.initialize();
  }

  @override
  void initState() {
    startCamera(0);
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    videoPlayerController?.dispose();
    recordingTimer?.cancel();
    timer?.cancel();
    super.dispose();
  }

  void startRecording() async {
    if (cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.startVideoRecording();
      setState(() {
        isRecording = true;
      });

      timer = Timer(const Duration(minutes: 2), stopRecording);
      recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          recordingDuration = Duration(seconds: timer.tick);
        });
      });
    } catch (e) {
      errorToast(msg: "Error starting video recording: $e");
    }
  }

  void stopRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      XFile video = await cameraController.stopVideoRecording();
      setState(() {
        isRecording = false;
      });

      final file = await saveVideo(video);
      setState(() {
        videoFile = file;
        MediaScanner.loadMedia(path: file.path);
        videoPlayerController = VideoPlayerController.file(file);
        initializeVideoPlayerFuture = videoPlayerController!.initialize();
      });
    } catch (e) {
      errorToast(msg: "Error stopping video recording: $e");
    } finally {
      timer?.cancel();
      recordingTimer?.cancel();
      setState(() {
        recordingDuration = Duration.zero;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(255, 255, 255, .7),
        shape: const CircleBorder(),
        onPressed: () {
          if (isRecording) {
            stopRecording();
          } else {
            startRecording();
          }
        },
        child: Icon(
          isRecording ? Icons.stop : Icons.videocam,
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
                    child: SizedBox(
                      width: 100,
                      child: CameraPreview(cameraController),
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
                child: isRecording
                    ? CustomText.ourText(
                        " ${recordingDuration.inMinutes.toString().padLeft(2, '0')}:${(recordingDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                      )
                    : const Text("Video Session"),
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
                        if (videoFile != null) {
                          getIt<CameraCubit>().addVideo(videoFile);
                          context.pop();
                        } else {
                          errorToast(msg: "Please record a video");
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
                      child: videoFile != null
                          ? FutureBuilder(
                              future: initializeVideoPlayerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return GestureDetector(
                                    onTap: () => CustomDialogs.showVideoDialog(
                                      context: context,
                                      videoUrl: videoFile!.path,
                                      isLocal: true,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: VideoPlayer(
                                                videoPlayerController!),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  videoFile = null;
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
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            )
                          : Container(),
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
