import 'dart:ui';

import 'package:paint/domain/shapes/shape.dart';
import 'package:paint/domain/shapes/shape_bounds.dart';

class SquareShape extends Shape {
  const SquareShape({
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
    canvas.drawRect(rect, fillPaint);

    final strokePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawRect(rect, strokePaint);
  }

  @override
  bool contains(Offset point) {
    return rect.inflate(strokeWidth / 2).contains(point);
  }
}
