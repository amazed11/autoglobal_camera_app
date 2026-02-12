import 'dart:io';

import 'package:autoglobal_camera_app/di_injection.dart';
import 'package:autoglobal_camera_app/src/core/app/dimensions.dart';
import 'package:autoglobal_camera_app/src/core/enums/enums.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/cubit/camera_cubit.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/cubit/upload_image_cubit.dart';
import 'package:autoglobal_camera_app/src/utils/custom_toasts.dart';
import 'package:autoglobal_camera_app/src/widgets/custom_button.dart';
import 'package:autoglobal_camera_app/src/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/routing/route_navigation.dart';
import '../../../../../../widgets/custom_dialogs.dart';
import 'all_image_card.dart';

class AllCarImageScreen extends StatelessWidget {
  const AllCarImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadImageCubit, UploadImageState>(
      listener: (context, state) {
        if (state.status == UploadImageStatus.loading) {
          CustomDialogs.fullLoadingDialog(
              context: context, data: state.message);
        }
        if (state.status == UploadImageStatus.failure) {
          back(context);
          errorToast(msg: state.message);
        }
        if (state.status == UploadImageStatus.success) {
          back(context);
          back(context);
          getIt<CameraCubit>().removeAll();
          successToast(msg: state.message);
        }
      },
      child: BlocBuilder<CameraCubit, CameraState>(
        builder: (ctx, state) {
          return Scaffold(
            appBar: AppBar(
              title: CustomText.ourText(
                "All Car Images",
                fontSize: 15,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton.elevatedButton(
                    "Confirm",
                    () {
                      if (getIt<CameraCubit>().state.coverPhotoValid == true &&
                          getIt<CameraCubit>().state.exteriorPhotosValid ==
                              true &&
                          getIt<CameraCubit>().state.interiorPhotosValid ==
                              true) {
                        CustomDialogs.customConfirmDialog(
                          context,
                          () {
                            context.pop();
                            getIt<UploadImageCubit>().uploadImages();
                          },
                          title: "Confirm Upload",
                          description:
                              "Are you sure you want to confirm to upload this images?",
                        );
                      } else {
                        warningToast(
                            msg:
                                "Please validate all the photos minimum requirement");
                      }
                    },
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                vSizedBox2,
                Container(
                  padding: screenLeftRightPadding,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(child: Text("Cover Image")),
                      // IconButton(
                      //   onPressed: () {
                      //     context.pushNamed(RouteConfig.reOrderImageRoute,
                      //         extra: ReorderImageModel(
                      //             images: state.exteriorPhotos,
                      //             cameraPurpose: CameraPurpose.exterior));
                      //   },
                      //   icon: const Icon(Icons.reorder_rounded),
                      // ),
                    ],
                  ),
                ),
                vSizedBox1andHalf,
                AllImageCard(
                  images: state.coverPhotos,
                  cameraPurpose: CameraPurpose.cover,
                ),
                vSizedBox2,
                Container(
                  padding: screenLeftRightPadding,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(child: Text("Exterior Image")),
                      // IconButton(
                      //   onPressed: () {
                      //     context.pushNamed(RouteConfig.reOrderImageRoute,
                      //         extra: ReorderImageModel(
                      //             images: state.exteriorPhotos,
                      //             cameraPurpose: CameraPurpose.exterior));
                      //   },
                      //   icon: const Icon(Icons.reorder_rounded),
                      // ),
                    ],
                  ),
                ),
                vSizedBox1andHalf,
                AllImageCard(
                  images: state.exteriorPhotos,
                  cameraPurpose: CameraPurpose.exterior,
                ),
                vSizedBox2,
                Container(
                  padding: screenLeftRightPadding,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(child: Text("Interior Image")),
                      // IconButton(
                      //   onPressed: () {
                      //     context.pushNamed(RouteConfig.reOrderImageRoute,
                      //         extra: ReorderImageModel(
                      //             images: state.interiorPhotos,
                      //             cameraPurpose: CameraPurpose.interior));
                      //   },
                      //   icon: const Icon(Icons.reorder_rounded),
                      // ),
                    ],
                  ),
                ),
                vSizedBox1andHalf,
                AllImageCard(
                  images: state.interiorPhotos,
                  cameraPurpose: CameraPurpose.interior,
                ),
                vSizedBox2,
                Container(
                  padding: screenLeftRightPadding,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(child: Text("Other Image")),
                      // IconButton(
                      //   onPressed: () {
                      //     context.pushNamed(RouteConfig.reOrderImageRoute,
                      //         extra: ReorderImageModel(
                      //             images: state.otherPhotos,
                      //             cameraPurpose: CameraPurpose.other));
                      //   },
                      //   icon: const Icon(Icons.reorder_rounded),
                      // ),
                    ],
                  ),
                ),
                vSizedBox1andHalf,
                AllImageCard(
                  images: state.otherPhotos,
                  cameraPurpose: CameraPurpose.other,
                ),
                vSizedBox2,
                Container(
                  padding: screenLeftRightPadding,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(child: Text("Video")),
                    ],
                  ),
                ),
                vSizedBox3,
                if (state.videos?.isNotEmpty == true)
                  VideoThumbnail(state.videos?.first.path),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VideoThumbnail extends StatefulWidget {
  String? videoPath;
  VideoThumbnail(this.videoPath, {super.key});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath!))
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 7, bottom: 75),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _controller.value.isInitialized
                    ? GestureDetector(
                        onTap: () => CustomDialogs.showVideoDialog(
                          context: context,
                          videoUrl: state.videos!.first.path,
                          isLocal: true,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: VideoPlayer(_controller),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    context.pop();
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
                      )
                    : Container(),
              ),
            ),
          ],
        );
      },
    );
  }
}
