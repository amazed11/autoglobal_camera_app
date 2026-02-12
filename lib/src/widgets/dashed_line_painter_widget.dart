import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import '../core/app/dimensions.dart';

Widget dashedLinePainterWidget(BuildContext context) {
  return CustomPaint(
    painter: DashedLinePainter(),
    child: SizedBox(
      width: appWidth(context),
      height: 0.6,
    ),
  );
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.kNeutral300 // Line color
      ..strokeWidth = 1.0 // Line thickness
      ..strokeCap = StrokeCap.round // Rounded line endings
      ..style = PaintingStyle.stroke;

    const dashWidth = 15; // Width of each dash
    const dashSpace = 8; // Space between dashes

    double startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(
          Offset(startX, size.height / 2), // Start point
          Offset(startX + dashWidth, size.height / 2), // End point
          paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
