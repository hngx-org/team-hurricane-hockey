import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SemiCirclePainter extends CustomPainter {
  final Color color;
  final bool isTop;

  SemiCirclePainter({required this.color, required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.w;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final radius = size.height / 2;

    final double startAngle = isTop ? 0 : -3.14159265;
    const sweepAngle = 3.14159265;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: radius,
      ),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
