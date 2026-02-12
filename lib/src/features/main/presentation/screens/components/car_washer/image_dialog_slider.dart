import 'dart:io';

import 'package:autoglobal_camera_app/src/core/app/dimensions.dart';
import 'package:flutter/material.dart';

class ImageDialog extends StatefulWidget {
  final List<File>? imagePaths;
  final int initialIndex;

  const ImageDialog({
    required this.imagePaths,
    required this.initialIndex,
    super.key,
  });

  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: appHeight(context) * 0.85,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.imagePaths?.length,
              itemBuilder: (context, index) {
                if (widget.imagePaths?.isNotEmpty ?? false) {
                  return InteractiveViewer(
                    child: Image.file(
                      widget.imagePaths?[index] ?? File(""),
                      fit: BoxFit.contain,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            if ((widget.imagePaths?.length ?? 0) > 1)
              Positioned(
                left: 10.0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            if ((widget.imagePaths?.length ?? 0) > 1)
              Positioned(
                right: 10.0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            Positioned(
              top: 10.0,
              right: 10.0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
