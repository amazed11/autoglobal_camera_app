import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import '../core/app/dimensions.dart';
import 'custom_button.dart';
import 'custom_network_image_widget.dart';
import 'custom_text.dart';

class CustomNotFoundWidget extends StatelessWidget {
  const CustomNotFoundWidget({
    Key? key,
    this.image,
    this.title,
    this.desc,
    this.showRefresh = false,
    this.showIcon = false,
    this.normalImage,
    this.onRefresh,
  }) : super(key: key);
  final String? image;
  final String? title;
  final String? desc;
  final bool? showRefresh;
  final Function()? onRefresh;
  final bool? showIcon;
  final bool? normalImage;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox(
          width: appWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (normalImage == true)
                CustomNetworkImage(
                  imageUrl: image ?? '',
                  height: 120,
                  width: 120,
                  boxFit: BoxFit.contain,
                ),
              vSizedBox2,
              CustomText.ourText(
                title ?? '',
                color: AppColor.kNeutral800,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              vSizedBox0,
              CustomText.ourText(
                desc ?? '',
                color: AppColor.kNeutral600,
                fontSize: 14,
              ),
              vSizedBox1,
              Visibility(
                visible: showRefresh == true,
                child: CustomButton.elevatedButton(
                  "Refresh",
                  onRefresh ?? () {},
                  fontSize: 15.0,
                  width: appWidth(context) * 0.4,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
