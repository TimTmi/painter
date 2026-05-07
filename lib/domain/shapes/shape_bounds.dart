import 'dart:math' as math;
import 'dart:ui';

class ShapeBounds {
  const ShapeBounds._();

  static Rect rectFromPoints(Offset start, Offset end) {
    return Rect.fromPoints(start, end);
  }

  static Rect squareFromPoints(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final side = math.min(dx.abs(), dy.abs());
    final squareEnd = Offset(
      start.dx + side * dx.sign,
      start.dy + side * dy.sign,
    );

    return Rect.fromPoints(start, squareEnd);
  }
}
