import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  Painter(double startingIndex, int length, this.color, this.textDirection) {
    final double span = 1.0 / length;
    offset = 0.2;
    final double l = startingIndex + (span - offset!) / 2;
    startingPosition = (textDirection == TextDirection.rtl) ? 0.8 - l : l;
  }
  double? startingPosition;
  Color? color;
  TextDirection? textDirection;
  double? offset;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color!
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo((startingPosition! - 0.08) * size.width, 0)
      ..cubicTo(
        (startingPosition! + offset! * 0.25) * size.width,
        size.height * 0.06,
        startingPosition! * size.width,
        size.height * 0.55,
        (startingPosition! + offset! * 0.50) * size.width,
        size.height * 0.55,
      )
      ..cubicTo(
        (startingPosition! + offset!) * size.width,
        size.height * 0.55,
        (startingPosition! + offset! - offset! * 0.25) * size.width,
        size.height * 0.06,
        (startingPosition! + offset! + 0.08) * size.width,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
