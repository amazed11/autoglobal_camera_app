import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import '../core/app/dimensions.dart';

void showCustomBottomSheet({
  required BuildContext context,
  required WidgetBuilder widgetBuilder,
  bool? isFromEdit = false,
  VoidCallback? onClose,
}) {
  showModalBottomSheet(
    elevation: 0.0,
    isScrollControlled: false,
    isDismissible: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    builder: (context) => SizedBox(
      width: appWidth(context),
      child: ListView(
        children: [
          vSizedBox1,
          Center(
            child: Container(
              width: 70,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.kNeutral200,
              ),
            ),
          ),
          vSizedBox1,
          widgetBuilder(context),
        ],
      ),
    ),
  ).whenComplete(
    () {
      if (onClose != null) {
        onClose();
      }
    },
  );
}
