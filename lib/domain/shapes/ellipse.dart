import 'dart:ui';

import 'package:paint/domain/shapes/shape.dart';
import 'package:paint/domain/shapes/shape_bounds.dart';

class EllipseShape extends Shape {
  const EllipseShape({
    required this.start,
    required this.end,
    required super.strokeColor,
    super.fillColor = const Color(0x00000000),
    required super.strokeWidth,
  });

  final Offset start;
  final Offset end;

  Rect get rect => ShapeBounds.rectFromPoints(start, end);

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
    final center = rect.center;
    final a = rect.width / 2 + strokeWidth / 2;
    final b = rect.height / 2 + strokeWidth / 2;
    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;
    return (dx * dx) / (a * a) + (dy * dy) / (b * b) <= 1.0;
  }

  @override
  EllipseShape copyWith({
    Color? strokeColor,
    Color? fillColor,
    double? strokeWidth,
  }) {
    return EllipseShape(
      start: start,
      end: end,
      strokeColor: strokeColor ?? this.strokeColor,
      fillColor: fillColor ?? this.fillColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}
