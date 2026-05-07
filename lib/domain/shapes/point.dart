import 'dart:ui';

import 'package:paint/domain/shapes/shape.dart';

class PointShape extends Shape {
  const PointShape({
    required this.center,
    required super.strokeColor,
    super.fillColor = const Color(0x00000000),
    required super.strokeWidth,
  });

  final Offset center;

  double get radius => strokeWidth / 2;

  @override
  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool contains(Offset point) {
    return (point - center).distance <= radius;
  }
}
