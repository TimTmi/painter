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

  @override
  bool contains(Offset point) {
    final v = end - start;
    final w = point - start;
    final t = (w.dx * v.dx + w.dy * v.dy) / (v.dx * v.dx + v.dy * v.dy);

    if (t < 0) return (point - start).distance <= strokeWidth / 2;
    if (t > 1) return (point - end).distance <= strokeWidth / 2;

    final projection = start + v * t;
    return (point - projection).distance <= strokeWidth / 2;
  }
}
