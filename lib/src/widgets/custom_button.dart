import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import 'custom_text.dart';

class CustomButton {
  static Widget customCircularButton({
    Color? backgroundColor,
    Color? iconColor,
    IconData? icon,
    Function()? onPressed,
    bool? isSVG,
    String? svgImage,
    EdgeInsets? wholePadding,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? AppColor.kcircularIcon,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
          icon ?? Icons.search,
          size: 22,
          color: iconColor ?? AppColor.kNeutral800,
        ),
      ),
    );
  }

  static Widget elevatedButton(
    String title,
    Function()? onPressed, {
    Color? titleColor,
    double? width,
    EdgeInsets? padding,
    double? height,
    double? fontSize = 16,
    FontWeight? fontWeight,
    bool isFitted = false,
    bool isDisable = false,
    Color? color,
    Color? borderColor,
    TextDecoration? decorateText,
    bool isBorder = false,
    double borderRadius = 12.0,
  }) {
    return SizedBox(
      width: width,
      height: height ?? 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: color,
          padding: padding,
          backgroundColor:
              isBorder ? Colors.transparent : color ?? AppColor.kPrimaryMain,
          disabledBackgroundColor: AppColor.kNeutral200,
          disabledForegroundColor: AppColor.kNeutral50,
          shape: RoundedRectangleBorder(
            side: isBorder == true
                ? BorderSide(
                    color: isDisable
                        ? AppColor.kNeutral400
                        : borderColor ?? AppColor.kPrimaryMain,
                    width: 2,
                  )
                : BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: isDisable ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Center(
            child: isFitted
                ? FittedBox(
                    child: CustomText.ourText(title,
                        fontSize: fontSize,
                        fontWeight: isBorder
                            ? FontWeight.w500
                            : fontWeight ?? FontWeight.w500,
                        color: isBorder
                            ? isDisable
                                ? AppColor.kNeutral400
                                : titleColor ?? AppColor.kPrimaryMain
                            : titleColor ?? Colors.white,
                        textDecoration: decorateText ?? TextDecoration.none),
                  )
                : CustomText.ourText(title,
                    fontSize: fontSize,
                    fontWeight: isBorder
                        ? FontWeight.w500
                        : fontWeight ?? FontWeight.w500,
                    color: isBorder
                        ? titleColor ?? Colors.black
                        : titleColor ??
                            (onPressed == null ? Colors.grey : Colors.white),
                    textDecoration: decorateText ?? TextDecoration.none),
          ),
        ),
      ),
    );
  }

  static Widget textButton(
    String title,
    Function()? onPressed, {
    Color? titleColor,
    double? width,
    double? height,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    bool? decorateText = false,
    bool isFitted = false,
    bool isDisable = false,
    Color? color,
    double borderRadius = 3.0,
    Color? backgroundColor,
    Color? textDecorationColor,
    bool? isBordered = false,
  }) {
    return SizedBox(
      width: width,
      height: height ?? 44,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: backgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: isBordered == true
                ? BorderSide(color: AppColor.kNeutral900)
                : BorderSide.none,
          ),
        ),
        onPressed: isDisable ? null : onPressed,
        child: Center(
          child: isFitted
              ? FittedBox(
                  child: CustomText.ourText(
                    title,
                    fontSize: fontSize,
                    fontWeight: fontWeight ?? FontWeight.w300,
                    color: titleColor ?? Colors.black,
                    fontStyle: fontStyle,
                  ),
                )
              : CustomText.ourText(
                  title,
                  fontSize: fontSize,
                  fontWeight: fontWeight ?? FontWeight.w300,
                  color: titleColor ?? Colors.black,
                  fontStyle: fontStyle,
                  textDecoration: decorateText == true
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: textDecorationColor ?? AppColor.kNeutral600,
                ),
        ),
      ),
    );
  }

  static Widget elevatedButtonWithIcon(
      {Key? key,
      required Function()? onPressed,
      VoidCallback? onLongPress,
      ValueChanged<bool>? onHover,
      ValueChanged<bool>? onFocusChange,
      ButtonStyle? style,
      FocusNode? focusNode,
      bool? autofocus,
      Clip? clipBehavior,
      Color? backGroundColour,
      MaterialStatesController? statesController,
      double? width,
      required Widget icon,
      required Widget label}) {
    return SizedBox(
      height: 44,
      width: width ?? double.infinity,
      child: ElevatedButton.icon(
        icon: icon,
        label: label,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backGroundColour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),
      ),
    );
  }

  static Widget textButtonWithIcon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    MaterialStatesController? statesController,
    required Widget icon,
    required Widget label,
    double borderRadius = 3.0,
    double? padding,
    Color? bgColor,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        icon: icon,
        label: label,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(padding ?? 0.0),
          disabledBackgroundColor: Colors.grey.shade400,
          backgroundColor: bgColor ?? Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
      ),
    );
  }

  static Widget customIconButton(
      {Key? key,
      double? iconSize,
      VisualDensity? visualDensity,
      EdgeInsetsGeometry? padding,
      AlignmentGeometry? alignment,
      double? splashRadius,
      Color? color,
      Color? focusColor,
      Color? hoverColor,
      Color? highlightColor,
      Color? splashColor,
      Color? disabledColor,
      required void Function()? onPressed,
      MouseCursor? mouseCursor,
      FocusNode? focusNode,
      bool autofocus = false,
      String? tooltip,
      bool? enableFeedback,
      BoxConstraints? constraints,
      ButtonStyle? style,
      bool? isSelected,
      Widget? selectedIcon,
      double? height,
      double? width,
      required Widget icon,
      Color? backgroundColor,
      double? borderRadius}) {
    return Container(
      height: height ?? 40,
      width: width ?? 42,
      decoration: BoxDecoration(
        color: onPressed == null ? disabledColor : backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 100),
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        splashRadius: splashRadius,
        splashColor: splashColor,
        padding: padding,
      ),
    );
  }

  static Widget textButtonWithTrailingIcon(
      {Key? key, dynamic onPressed, String? buttonText, Icon? trailingIcon}) {
    return TextButton(
        style: TextButton.styleFrom(backgroundColor: AppColor.appBarBackground),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buttonText ?? 'N/A',
            ),
            trailingIcon ?? const SizedBox.shrink()
          ],
        ));
  }
}
