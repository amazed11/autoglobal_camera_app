import 'dart:io';
import 'package:flutter/material.dart';

import 'custom_text.dart';

Future<void> customImageViewWidget(BuildContext context, String? path) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          child: path != null
              ? Image.file(
                  height: 500,
                  // width: 150,
                  fit: BoxFit.cover,
                  File(path),
                )
              : CustomText.ourText(""),
        ),
      );
    },
  );
}
