import 'package:flutter/material.dart';

import '../core/app/colors.dart';

class CustomDivider {
  static Widget ourDivider(
      {Key? key,
      double? height,
      double? thickness,
      double? indent,
      double? endIndent,
      Color? color}) {
    return (Divider(
      endIndent: endIndent,
      thickness: thickness,
      color: color ?? AppColor.kNeutral200,
    ));
  }
}
