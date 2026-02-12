import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import 'custom_text.dart';

class CustomCircleNameAvatarImageWidget extends StatelessWidget {
  final String? name;
  final double? height;
  final double? width;
  final double? padding;
  final bool? isLeadingEdit;

  const CustomCircleNameAvatarImageWidget({
    Key? key,
    this.name,
    this.height,
    this.width,
    this.padding,
    this.isLeadingEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(padding ?? 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.kNeutral200,
      ),
      child: Stack(
        children: [
          Center(
            child: CustomText.ourText(
              name
                  ?.trim()
                  .split(RegExp(' +'))
                  .map((s) => s[0])
                  .take(2)
                  .join()
                  .toUpperCase(),
              maxLines: 1,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isLeadingEdit == true)
            Positioned(
              bottom: 2,
              right: -3,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                height: 20,
                width: 20,
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 16,
                ),
              ),
            )
        ],
      ),
    );
  }
}
