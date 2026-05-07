import 'dart:ui';

import 'package:paint/domain/shapes/shape.dart';

class LineShape extends Shape {
  const LineShape({
    required this.start,
    required this.end,
    required super.strokeColor,
    super.fillColor = const Color(0x00000000),
    required super.strokeWidth,
  });

  final Offset start;
  final Offset end;

  @override
  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }
}
