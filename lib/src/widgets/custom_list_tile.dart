import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import 'custom_network_image_widget.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    this.title = '',
    this.isIgnoreLeading = false,
    this.normalTrailingIcon = false,
    this.showLeading = true,
    this.isShowSubtitle = false,
    this.subTitle = '',
    this.svgleadingIcon,
    this.issvgleadingIcon = true,
    this.isTrailing = false,
    this.isLeadingEdit = false,
    this.isNetworkImage,
    this.trailingWidget,
    this.svgtrailingIcon = '',
    this.trailingIcon,
    this.normalIcon,
    this.onTap,
    this.name,
    this.networkImageUrl,
    this.titleFontSize,
    this.subtitleFontSize,
    this.titleFontWeight,
    this.subtitleFontWeight,
    this.svgHeight,
    this.svgWidth,
    this.customImage,
    this.isCustomImage = false,
    this.subTitleColor,
    this.titleColor,
    this.leadingWidget,
    this.isThreeLines,
    this.insidePadding,
    this.onLeadingTap,
    this.isDense = false,
    this.isNormalLeading,
    this.showVerified = false,
  }) : super(key: key);
  final String? title;
  final bool? isIgnoreLeading;
  final bool? normalTrailingIcon;
  final bool? showLeading;
  final bool? isShowSubtitle;
  final String? subTitle;
  final String? svgleadingIcon;
  final bool? issvgleadingIcon;
  final bool? isTrailing;
  final bool? isLeadingEdit;
  final bool? isNetworkImage;
  final Widget? trailingWidget;
  final Widget? leadingWidget;
  final String? svgtrailingIcon;
  final IconData? trailingIcon;
  final IconData? normalIcon;
  final Function()? onTap;
  final String? name;
  final String? networkImageUrl;
  final double? titleFontSize;
  final double? subtitleFontSize;
  final FontWeight? titleFontWeight;
  final FontWeight? subtitleFontWeight;
  final double? svgHeight;
  final double? svgWidth;
  final String? customImage;
  final bool? isCustomImage;
  final Color? subTitleColor;
  final Color? titleColor;
  final bool? isThreeLines;
  final bool? isNormalLeading;
  final dynamic insidePadding;
  final Function()? onLeadingTap;
  final bool? isDense;
  final bool? showVerified;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: isDense,
      isThreeLine: isThreeLines ?? false,
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      minVerticalPadding: 0,
      minLeadingWidth: 0,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      leading: showLeading == false
          ? null
          : leadingWidget ??
              (isNetworkImage == true
                  ? ClipOval(
                      child: CustomNetworkImage(
                        imageUrl: networkImageUrl,
                        height: 50,
                        width: 50,
                      ),
                    )
                  : isNormalLeading == true
                      ? Icon(
                          normalIcon,
                          size: 30,
                          color: AppColor.kPrimaryMain,
                        )
                      : null),
      title: Text(
        title ?? '',
        style: TextStyle(
          fontWeight: titleFontWeight ?? FontWeight.w500,
          fontSize: titleFontSize ?? 16,
          color: titleColor ?? AppColor.kNeutral800,
        ),
      ),
      subtitle: isShowSubtitle == true
          ? Text(
              subTitle ?? '',
              style: TextStyle(
                fontWeight: subtitleFontWeight ?? FontWeight.w400,
                fontSize: subtitleFontSize ?? 12,
                color: subTitleColor,
              ),
            )
          : null,
      trailing: trailingWidget ??
          (isTrailing == false
              ? null
              : Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    trailingIcon ?? CupertinoIcons.chevron_forward,
                    color: AppColor.kNeutral600,
                    size: 22,
                  ),
                )),
    );
  }
}
