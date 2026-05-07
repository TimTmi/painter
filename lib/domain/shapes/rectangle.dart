import 'dart:ui';

import 'package:paint/domain/shapes/shape.dart';

class RectangleShape extends Shape {
  const RectangleShape({
    required this.start,
    required this.end,
    required super.strokeColor,
    super.fillColor = const Color(0x00000000),
    required super.strokeWidth,
  });

  final Offset start;
  final Offset end;

  Rect get rect => Rect.fromPoints(start, end);

  @override
  void draw(Canvas canvas) {
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);

    final strokePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawRect(rect, strokePaint);
  }
}
