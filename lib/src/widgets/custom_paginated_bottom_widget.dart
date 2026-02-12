import 'package:flutter/material.dart';
import '../core/app/texts.dart';
import 'custom_text.dart';

class CustomPaginatedBottomWidget extends StatelessWidget {
  final bool? hasNext;
  final String? title;
  const CustomPaginatedBottomWidget({
    Key? key,
    this.hasNext = false,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hasNext == false
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CustomText.ourText(
                "$noMoreText $title $toLoadText.",
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          )
        : const Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
            ),
          );
  }
}
