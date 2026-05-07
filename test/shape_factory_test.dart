import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paint/application/shape_factory.dart';
import 'package:paint/application/tool_type.dart';
import 'package:paint/domain/shapes/circle.dart';
import 'package:paint/domain/shapes/ellipse.dart';
import 'package:paint/domain/shapes/line.dart';
import 'package:paint/domain/shapes/point.dart';
import 'package:paint/domain/shapes/rectangle.dart';
import 'package:paint/domain/shapes/shape_bounds.dart';
import 'package:paint/domain/shapes/square.dart';

void main() {
  group('ShapeBounds', () {
    test('normalizes rectangle bounds from any drag direction', () {
      final rect = ShapeBounds.rectFromPoints(
        const Offset(30, 40),
        const Offset(10, 5),
      );

      expect(rect, const Rect.fromLTRB(10, 5, 30, 40));
    });

    test('creates square bounds anchored at start with drag direction', () {
      final rect = ShapeBounds.squareFromPoints(
        const Offset(10, 10),
        const Offset(4, 20),
      );

      expect(rect, const Rect.fromLTRB(4, 10, 10, 16));
      expect(rect.width, rect.height);
    });

    test('creates square bounds for every drag quadrant', () {
      const start = Offset(10, 10);

      expect(
        ShapeBounds.squareFromPoints(start, const Offset(18, 16)),
        const Rect.fromLTRB(10, 10, 16, 16),
      );
      expect(
        ShapeBounds.squareFromPoints(start, const Offset(2, 16)),
        const Rect.fromLTRB(4, 10, 10, 16),
      );
      expect(
        ShapeBounds.squareFromPoints(start, const Offset(18, 4)),
        const Rect.fromLTRB(10, 4, 16, 10),
      );
      expect(
        ShapeBounds.squareFromPoints(start, const Offset(2, 4)),
        const Rect.fromLTRB(4, 4, 10, 10),
      );
    });
  });

  group('ShapeFactory', () {
    const start = Offset(10, 20);
    const end = Offset(50, 80);
    const strokeColor = Color(0xFFFF0000);
    const fillColor = Color(0x330000FF);
    const strokeWidth = 4.0;

    test('creates point from start point', () {
      final shape = ShapeFactory.create(
        toolType: ToolType.point,
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      );

      expect(shape, isA<PointShape>());
      final point = shape as PointShape;
      expect(point.center, start);
      expect(point.radius, strokeWidth / 2);
      expect(point.strokeColor, strokeColor);
      expect(point.fillColor, fillColor);
      expect(point.strokeWidth, strokeWidth);
    });

    test('creates a concrete shape for every drawing tool', () {
      final expectedTypes = <ToolType, Type>{
        ToolType.point: PointShape,
        ToolType.line: LineShape,
        ToolType.rectangle: RectangleShape,
        ToolType.square: SquareShape,
        ToolType.circle: CircleShape,
        ToolType.ellipse: EllipseShape,
      };

      for (final entry in expectedTypes.entries) {
        final shape = ShapeFactory.create(
          toolType: entry.key,
          start: start,
          end: end,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
        );

        expect(shape.runtimeType, entry.value);
      }
    });

    test('creates line from start and end', () {
      final shape = ShapeFactory.create(
        toolType: ToolType.line,
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      );

      expect(shape, isA<LineShape>());
      final line = shape as LineShape;
      expect(line.start, start);
      expect(line.end, end);
    });

    test('creates rectangle with normalized bounds', () {
      final shape = ShapeFactory.create(
        toolType: ToolType.rectangle,
        start: const Offset(50, 80),
        end: const Offset(10, 20),
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      );

      expect(shape, isA<RectangleShape>());
      expect(
        (shape as RectangleShape).rect,
        const Rect.fromLTRB(10, 20, 50, 80),
      );
    });

    test('creates ellipse with normalized bounds', () {
      final shape = ShapeFactory.create(
        toolType: ToolType.ellipse,
        start: const Offset(50, 80),
        end: const Offset(10, 20),
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      );

      expect(shape, isA<EllipseShape>());
      expect((shape as EllipseShape).rect, const Rect.fromLTRB(10, 20, 50, 80));
    });

    test('creates square using the shorter drag side', () {
      final shape = ShapeFactory.create(
        toolType: ToolType.square,
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      );

      expect(shape, isA<SquareShape>());
      final rect = (shape as SquareShape).rect;
      expect(rect, const Rect.fromLTRB(10, 20, 50, 60));
      expect(rect.width, rect.height);
    });

    test('creates circle using square bounds', () {
      final shape = ShapeFactory.create(
        toolType: ToolType.circle,
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      );

      expect(shape, isA<CircleShape>());
      final rect = (shape as CircleShape).rect;
      expect(rect, const Rect.fromLTRB(10, 20, 50, 60));
      expect(rect.width, rect.height);
    });
  });
}
