import 'package:autoglobal_camera_app/src/core/app/dimensions.dart';
import 'package:autoglobal_camera_app/src/core/configs/route_config.dart';
import 'package:autoglobal_camera_app/src/features/main/presentation/screens/components/cubit/camera_cubit.dart';
import 'package:autoglobal_camera_app/src/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../di_injection.dart';
import '../../../../../../core/app/medias.dart';
import '../../../../../../widgets/custom_button.dart';
import '../../../../../auth/presentation/cubit/auth_cubit.dart';
import 'user_guide_cover_photo_dialog.dart';

class CarWasherScreen extends StatelessWidget {
  const CarWasherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Car Washer"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.info_outline),
              ),
              IconButton(
                onPressed: () {
                  getIt<AuthCubit>().logout();
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Padding(
            padding: screenLeftRightPadding,
            child: ListView(
              children: [
                // CustomButton.elevatedButton("Angle", () {
                //   navigate(
                //     context,
                //     CameraScreen(
                //       cameras: cameras,
                //     ),
                //   );
                // }),
                // vSizedBox2,
                // CustomButton.elevatedButton("New Detector", () {
                //   navigate(
                //     context,
                //     const ObjectDetectorView(),
                //   );
                // }),
                vSizedBox2,
                Container(
                  padding: screenPadding,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(children: [
                    CustomText.ourText(
                      "~ ${"Toyoto XCar"}",
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                    vSizedBox1andHalf,
                    const Wrap(
                      spacing: 10,
                      runSpacing: 5,
                      children: [
                        ListingCategoryWidget(
                          data: "2022 May 10",
                          icon: Icons.date_range_outlined,
                        ),
                        ListingCategoryWidget(
                          data: "2020",
                          icon: Icons.timeline_outlined,
                        ),
                        ListingCategoryWidget(
                          data: "Petrol",
                          icon: Icons.local_gas_station_outlined,
                        ),
                        ListingCategoryWidget(
                          data: "120000 km",
                          icon: Icons.speed,
                        ),
                        ListingCategoryWidget(
                          data: "120 km/hr",
                          icon: Icons.rocket_launch_rounded,
                        ),
                        ListingCategoryWidget(
                          data: "123456",
                          icon: Icons.numbers_outlined,
                        ),
                        ListingCategoryWidget(
                          data: "Hg T3 3233",
                          icon: Icons.car_rental_outlined,
                        ),
                      ],
                    ),
                  ]),
                ),
                vSizedBox2,
                CustomText.ourText(
                  "Options",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                CustomText.ourText("Select picture type you want to click."),
                vSizedBox2,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: state.coverPhotoValid == true
                          ? Colors.green.shade300
                          : Colors.grey.shade300,
                    ),
                    color: state.coverPhotoValid == true
                        ? Colors.green.withOpacity(0.2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(5),
                    leading: Icon(
                      Icons.check_circle,
                      color: state.coverPhotoValid == true
                          ? Colors.green
                          : Colors.grey,
                    ),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "* ",
                            style: TextStyle(
                              color: state.coverPhotoValid == true
                                  ? Colors.grey
                                  : Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          const TextSpan(
                            text: "Cover Picture",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      "Expected at least 1 image",
                      style: TextStyle(
                        color: state.coverPhotoValid == true
                            ? Colors.grey
                            : Colors.red,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UserGuideCoverPhotoDialog(
                            imagePaths: [
                              kSample1,
                              kSample2,
                              kSample3,
                              kSample4,
                            ],
                            descriptions: const [
                              'Make sure the car is centered and the image is taken from the side.',
                              'Ensure the entire car is visible in the frame.',
                              'Avoid any obstructions and ensure good lighting.',
                              'Make sure the car angle is properly adjusted.',
                            ],
                          );
                        },
                      );
                      print("cover photo");
                      // context.goNamed(RouteConfig.coverImageRoute);
                    },
                    trailing: Text(
                      "${state.coverPhotos?.length ?? 0}/1",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                vSizedBox1,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: state.exteriorPhotosValid == true
                          ? Colors.green.shade300
                          : Colors.grey.shade300,
                    ),
                    color: state.exteriorPhotosValid == true
                        ? Colors.green.withOpacity(0.2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(5),
                    leading: Icon(
                      Icons.check_circle,
                      color: state.exteriorPhotosValid == true
                          ? Colors.green
                          : Colors.grey,
                    ),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "* ",
                            style: TextStyle(
                              color: state.exteriorPhotosValid == true
                                  ? Colors.grey
                                  : Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          const TextSpan(
                            text: "Exterior Picture",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      "Expected at least 4 image",
                      style: TextStyle(
                        color: state.exteriorPhotosValid == true
                            ? Colors.grey
                            : Colors.red,
                      ),
                    ),
                    onTap: () {
                      context.pushNamed(RouteConfig.exteriorImageRoute);
                    },
                    trailing: Text(
                      "${state.exteriorPhotos?.length ?? 0}/6",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                vSizedBox1,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: state.interiorPhotosValid == true
                          ? Colors.green.shade300
                          : Colors.grey.shade300,
                    ),
                    color: state.interiorPhotosValid == true
                        ? Colors.green.withOpacity(0.2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(5),
                    leading: Icon(
                      Icons.check_circle,
                      color: state.interiorPhotosValid == true
                          ? Colors.green
                          : Colors.grey,
                    ),
                    onTap: () {
                      context.pushNamed(RouteConfig.interiorImageRoute);
                    },
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "* ",
                            style: TextStyle(
                              color: state.interiorPhotosValid == true
                                  ? Colors.grey
                                  : Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          const TextSpan(
                            text: "Interior Picture",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      "Expected at least 6 image",
                      style: TextStyle(
                        color: state.interiorPhotosValid == true
                            ? Colors.grey
                            : Colors.red,
                      ),
                    ),
                    trailing: Text(
                      "${state.interiorPhotos?.length ?? 0}/10",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                vSizedBox1,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: state.otherPhotosValid == true
                          ? Colors.green.shade300
                          : Colors.grey.shade300,
                    ),
                    color: state.otherPhotosValid == true
                        ? Colors.green.withOpacity(0.2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(5),
                    leading: Icon(
                      Icons.check_circle,
                      color: state.otherPhotosValid == true
                          ? Colors.green
                          : Colors.grey,
                    ),
                    onTap: () {
                      context.pushNamed(RouteConfig.otherImageRoute);
                    },
                    title: const Text("Others Picture"),
                    subtitle: const Text(
                      "Optional",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Text(
                      "${state.otherPhotos?.length ?? 0}/5",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                vSizedBox1,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: state.videoValid == true
                          ? Colors.green.shade300
                          : Colors.grey.shade300,
                    ),
                    color: state.otherPhotosValid == true
                        ? Colors.green.withOpacity(0.2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(5),
                    leading: Icon(
                      Icons.check_circle,
                      color:
                          state.videoValid == true ? Colors.green : Colors.grey,
                    ),
                    onTap: () {
                      context.pushNamed(RouteConfig.videoRoute);
                    },
                    title: const Text("Videos"),
                    subtitle: const Text(
                      "Optional",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Text(
                      "${state.videos?.length ?? 0}/1",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                vSizedBox3,
                CustomButton.elevatedButton(
                  "View Images",
                  () {
                    context.pushNamed(RouteConfig.allImageRoute);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ListingCategoryWidget extends StatelessWidget {
  const ListingCategoryWidget({
    super.key,
    required this.data,
    this.icon,
  });

  final dynamic data;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: Colors.grey,
              size: 17,
            ),
          hSizedBox0,
          Flexible(
            child: CustomText.ourText(
              "${data ?? '-'}",
              fontSize: 10,
              maxLines: 1,
              color: Colors.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
