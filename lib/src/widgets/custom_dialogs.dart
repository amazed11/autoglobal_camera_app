import 'dart:io';

import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import '../core/app/dimensions.dart';
import '../core/app/texts.dart';
import '../core/routing/route_navigation.dart';
import '../core/states/states.dart';
import '../features/main/presentation/screens/components/car_washer/video_player.dart';
import 'custom_button.dart';
import 'custom_network_image_widget.dart';
import 'custom_text.dart';

class CustomDialogs {
  static void cancelDialog(context) {
    back(context);
  }

  static fullLoadingDialog(
      {String? data, BuildContext? context, Color? color}) {
    showGeneralDialog(
      context: context ?? navigatorKey.currentContext!,
      barrierDismissible: false,
      barrierColor: const Color(0xff141A31).withOpacity(0.3),
      barrierLabel: data ?? loadingText,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.2),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        color ?? AppColor.kPrimaryMain,
                      ),
                    ),
                  ),
                  vSizedBox0,
                  Text(
                    data ?? loadingText,
                    style: TextStyle(
                      color: color ?? Colors.white,
                      fontSize: 11,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showImageDialog({
    required BuildContext context,
    bool? isLocal = false,
    String? imageUrl,
  }) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return PopScope(
            canPop: true,
            child: Dialog(
              elevation: 0.0,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              backgroundColor: Colors.transparent,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        isLocal ?? false
                            ? InteractiveViewer(
                                clipBehavior: Clip.none,
                                child: Image.file(File(imageUrl ?? "")))
                            : imageUrl != null
                                ? InteractiveViewer(
                                    child: CustomNetworkImage(
                                      isAutoHeight: true,
                                      imageUrl: imageUrl,
                                      width: appWidth(context),
                                      boxFit: BoxFit.contain,
                                    ),
                                  )
                                : Container(),
                        Positioned(
                          right: 0,
                          child: IconButton.filledTonal(
                            onPressed: () {
                              back(context);
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> infoDialog(
    BuildContext context,
    String? titleText,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  vSizedBox1,
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColor.kPrimaryMain,
                    size: 40,
                  ),
                  vSizedBox1andHalf,
                  Text(
                    "$titleText",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColor.kNeutral800,
                      fontSize: 15,
                    ),
                  ),
                  vSizedBox2,
                  CustomButton.elevatedButton(
                    "Ok",
                    titleColor: AppColor.kPrimaryMain,
                    borderRadius: 5,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColor.kSecondaryButton,
                    () {
                      back(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showNoCarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Car Detected"),
          content: const Text(
              "It seems that there is no car inside the image. Please retake the image properly."),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool> customConfirmDialog(
    BuildContext context,
    Function() onSelectedYes, {
    String? description,
    String? title,
    String? actionText1,
    String? actionText2,
    double? actionText2FontSize,
    double? actionText1FontSize,
    Color? actionText1Color,
    Color? actionText2Color,
    Widget? extraWidget,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    CustomText.ourText(
                      title,
                      fontWeight: FontWeight.w800,
                      color: AppColor.kNeutral800,
                      fontSize: 20,
                      textAlign: TextAlign.center,
                    ),
                    vSizedBox1,
                  ],
                  if (description != null) ...[
                    CustomText.ourText(
                      description,
                      fontWeight: FontWeight.w400,
                      color: AppColor.kNeutral600,
                      fontSize: 14,
                      maxLines: 8,
                      textAlign: TextAlign.center,
                    ),
                    vSizedBox1,
                  ],
                  if (extraWidget != null) extraWidget,
                  vSizedBox1,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton.elevatedButton(
                        actionText1 ?? "Yes",
                        titleColor: Colors.white,
                        borderRadius: 5,
                        fontWeight: FontWeight.w500,
                        fontSize: actionText1FontSize ?? 16,
                        color: Colors.blue,
                        onSelectedYes,
                      ),
                      vSizedBox1,
                      CustomButton.textButton(
                        actionText2 ?? "No",
                        color: actionText2Color ?? Colors.white,
                        titleColor: Colors.black54,
                        borderRadius: 5,
                        fontWeight: FontWeight.w500,
                        fontSize: actionText2FontSize ?? 16,
                        () {
                          back(context);
                        },
                        backgroundColor: AppColor.kSecondaryButton,
                      ),
                      vSizedBox1,
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showVideoDialog({
    required BuildContext context,
    required String videoUrl,
    required bool isLocal,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLocal
                  ? VideoPlayerWidget(videoFile: File(videoUrl))
                  : const Text("Video not supported yet"),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
