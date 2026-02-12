import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import '../core/app/texts.dart';
import 'custom_button.dart';
import 'custom_text.dart';

class CustomSeeAllWidget extends StatelessWidget {
  final String? text;
  final Function()? onClick;
  const CustomSeeAllWidget(
      {Key? key, required this.text, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText.ourText(
          text,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColor.kNeutral900,
        ),
        CustomButton.textButton(
          seeAllText,
          () {
            onClick!();
          },
          fontSize: 14,
          fontWeight: FontWeight.w500,
          decorateText: true,
          titleColor: AppColor.kPrimaryMain,
        )
      ],
    );
  }
}
