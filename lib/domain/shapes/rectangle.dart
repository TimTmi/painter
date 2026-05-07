import 'dart:ui';

import 'package:paint/domain/shapes/shape.dart';
import 'package:paint/domain/shapes/shape_bounds.dart';

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

  Rect get rect => ShapeBounds.rectFromPoints(start, end);

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    paint
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paint);

    paint
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawRect(rect, paint);
  }
}
