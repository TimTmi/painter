import 'dart:ui';

abstract class Shape {
  const Shape({
    required this.strokeColor,
    required this.fillColor,
    required this.strokeWidth,
  }) : assert(strokeWidth > 0, 'strokeWidth must be greater than zero');

  final Color strokeColor;
  final Color fillColor;
  final double strokeWidth;

  void draw(Canvas canvas);
}
