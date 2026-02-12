import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import 'custom_text.dart';

class CustomChip {
  static Widget basicChip({
    required Function() onPressed,
    required Function()? onDelete,
    String? labelText,
    required bool? isSelected,
  }) {
    return GestureDetector(
      onTap: onPressed.call(),
      child: Chip(
        label: CustomText.ourText(
          labelText,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: isSelected == true ? AppColor.kWhite : AppColor.kNeutral400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide.none,
        ),
        side: BorderSide(
          color:
              isSelected == true ? AppColor.kPrimaryMain : AppColor.kNeutral400,
        ),
        backgroundColor:
            isSelected == true ? AppColor.kPrimaryMain : AppColor.kWhite,
        deleteIcon: Icon(
          CupertinoIcons.clear_circled,
          color: AppColor.kWhite,
          size: 18,
        ),
        onDeleted: onDelete,
      ),
    );
  }
}
