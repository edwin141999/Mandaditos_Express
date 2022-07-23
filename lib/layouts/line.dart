
import 'package:flutter/material.dart';

class Line extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    const p1 = Offset(0, 0);
    final p2 = Offset(size.width, 0);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}