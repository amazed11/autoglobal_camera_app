import 'package:flutter/material.dart';
import '../core/app/colors.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.titleFontSize = 22,
    this.action,
    this.isAutomaticallyImplyLeading,
    this.bgColor,
    this.titleFontWeight = FontWeight.w700,
    this.centerTitle,
    this.alignTitleText,
    this.leading,
    this.bottom,
    this.titleWidget,
  }) : super(key: key);
  final String? title;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final List<Widget>? action;
  final Color? bgColor;
  final bool? isAutomaticallyImplyLeading;
  final Alignment? alignTitleText;
  final bool? centerTitle;
  final Widget? leading;
  final Widget? titleWidget;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ??
          ((alignTitleText == null)
              ? CustomText.ourText(
                  title ?? '',
                  fontSize: titleFontSize,
                  fontWeight: titleFontWeight,
                  maxLines: 1,
                  color: AppColor.kNeutral800,
                )
              : Align(
                  alignment: alignTitleText ?? Alignment.topLeft,
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: titleFontWeight,
                      // : 1,
                    ),
                  ))),
      centerTitle: centerTitle ?? true,
      automaticallyImplyLeading: isAutomaticallyImplyLeading ?? true,
      elevation: 0,
      actions: action ?? [],
      backgroundColor: bgColor,
      leading: leading,
      bottom: bottom,
    );
  }
}
