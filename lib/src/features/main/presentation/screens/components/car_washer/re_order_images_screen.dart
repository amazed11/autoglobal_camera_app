import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../../../di_injection.dart';
import '../../../../../../core/enums/enums.dart';
import '../../../../../../widgets/custom_dialogs.dart';
import '../cubit/camera_cubit.dart';

class ReorderImageModel {
  final List<File>? images;
  final CameraPurpose cameraPurpose;

  ReorderImageModel({required this.images, required this.cameraPurpose});
}

class ReorderImageScreen extends StatefulWidget {
  const ReorderImageScreen({
    Key? key,
    required this.reorderImageModel,
  }) : super(key: key);

  final ReorderImageModel? reorderImageModel;

  @override
  _ReorderImageScreenState createState() => _ReorderImageScreenState();
}

class _ReorderImageScreenState extends State<ReorderImageScreen> {
  late List<File> images;

  @override
  void initState() {
    super.initState();
    images = List<File>.from(widget.reorderImageModel?.images ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            var data = images[index];
            return Draggable<File>(
              data: data,
              feedback: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  height: 100,
                  width: 100,
                  image: FileImage(data),
                  fit: BoxFit.cover,
                ),
              ),
              childWhenDragging: Container(
                height: 100,
                width: 100,
                color: Colors.transparent,
              ),
              child: DragTarget<File>(
                onAccept: (receivedItem) {
                  setState(() {
                    final int currentIndex = images.indexOf(data);
                    final int newIndex = images.indexOf(receivedItem);
                    images.removeAt(currentIndex);
                    images.insert(newIndex, data);
                  });
                },
                builder: (context, acceptedItems, rejectedItems) =>
                    GestureDetector(
                  onTap: () => CustomDialogs.showImageDialog(
                    context: context,
                    imageUrl: data.path,
                    isLocal: true,
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          height: 100,
                          width: 100,
                          opacity: const AlwaysStoppedAnimation(0.7),
                          image: FileImage(data),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 13,
                        top: 0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              images.removeAt(index);
                            });
                            _removeImage(data);
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
              ),
            );
          },
        ),
      ),
    );
  }

  void _removeImage(File image) {
    // Remove the image based on the camera purpose
    if (widget.reorderImageModel?.cameraPurpose == CameraPurpose.cover) {
      getIt<CameraCubit>().removeCoverPhoto(image);
    } else if (widget.reorderImageModel?.cameraPurpose ==
        CameraPurpose.exterior) {
      getIt<CameraCubit>().removeExteriorPhoto(image);
    } else if (widget.reorderImageModel?.cameraPurpose ==
        CameraPurpose.interior) {
      getIt<CameraCubit>().removeInteriorPhoto(image);
    } else if (widget.reorderImageModel?.cameraPurpose == CameraPurpose.other) {
      getIt<CameraCubit>().removeOtherPhoto(image);
    }
  }
}
