import 'package:flutter/material.dart';

class DottedPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  DottedPainter({this.strokeWidth = 1.0, this.color = Colors.grey});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const gap = 5.0;
    final count = (size.width / (gap * 2)).floor();
    final dashWidth = (size.width - (gap * (count - 1))) / count;

    var startX = 0.0;
    var startY = 0.0;

    for (var i = 0; i < count; i++) {
      canvas.drawLine(
          Offset(startX, startY), Offset(startX + dashWidth, startY), paint);
      startX += dashWidth + gap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
