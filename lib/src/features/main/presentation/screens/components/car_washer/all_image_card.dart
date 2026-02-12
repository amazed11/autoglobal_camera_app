import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../../../di_injection.dart';
import '../../../../../../core/app/dimensions.dart';
import '../../../../../../core/enums/enums.dart';
import '../cubit/camera_cubit.dart';
import 'image_dialog_slider.dart';

class AllImageCard extends StatelessWidget {
  const AllImageCard({
    super.key,
    this.images,
    this.cameraPurpose = CameraPurpose.cover,
  });
  final List<File>? images;
  final CameraPurpose cameraPurpose;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: screenLeftRightPadding,
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: List.generate(images?.length ?? 0, (index) {
          var data = images?[index];
          return GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => ImageDialog(
                imagePaths: images,
                initialIndex: index,
              ),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    height: 100,
                    width: 100,
                    opacity: const AlwaysStoppedAnimation(07),
                    image: FileImage(
                      File(data!.path),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      if (cameraPurpose == CameraPurpose.cover) {
                        getIt<CameraCubit>().removeCoverPhoto(data);
                      }
                      if (cameraPurpose == CameraPurpose.exterior) {
                        getIt<CameraCubit>().removeExteriorPhoto(data);
                      }
                      if (cameraPurpose == CameraPurpose.interior) {
                        getIt<CameraCubit>().removeInteriorPhoto(data);
                      }
                      if (cameraPurpose == CameraPurpose.other) {
                        getIt<CameraCubit>().removeOtherPhoto(data);
                      }
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
