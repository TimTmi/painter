import 'dart:ui';

import 'package:paint/domain/shapes/shape.dart';
import 'package:paint/domain/shapes/shape_bounds.dart';

class CircleShape extends Shape {
  const CircleShape({
    required this.start,
    required this.end,
    required super.strokeColor,
    super.fillColor = const Color(0x00000000),
    required super.strokeWidth,
  });

  final Offset start;
  final Offset end;

  Rect get rect => ShapeBounds.squareFromPoints(start, end);

  @override
  void draw(Canvas canvas) {
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawOval(rect, fillPaint);

    final strokePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawOval(rect, strokePaint);
  }

  @override
  bool contains(Offset point) {
    return (point - rect.center).distance <= (rect.width / 2 + strokeWidth / 2);
  }
}
