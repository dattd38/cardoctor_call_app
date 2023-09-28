import 'dart:math';

import 'package:flutter/material.dart';

class PulseWidget extends CustomPainter {
  final Animation<double> _animation;
  final Color color;
  final int wave;

  PulseWidget(this._animation,{ required this.color,required this.wave}) : super(repaint: _animation);

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);

    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = sqrt(area * value / 4);

    final Paint paint = Paint()..color = color.withOpacity(opacity);
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int i = wave; i >= 0; i--) {
      circle(canvas, rect, i + _animation.value);
    }
  }

  @override
  bool shouldRepaint(PulseWidget oldDelegate) {
    return true;
  }
}
