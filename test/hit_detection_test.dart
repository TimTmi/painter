import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:paint/application/canvas_state.dart';
import 'package:paint/domain/shapes/line.dart';
import 'package:paint/domain/shapes/rectangle.dart';
import 'package:paint/domain/shapes/circle.dart';
import 'package:paint/domain/shapes/ellipse.dart';
import 'package:paint/domain/shapes/point.dart';

void main() {
  group('Shape hit detection', () {
    test('LineShape contains point', () {
      const shape = LineShape(
        start: Offset(0, 0),
        end: Offset(100, 100),
        strokeColor: Color(0xFF000000),
        strokeWidth: 10,
      );

      expect(shape.contains(const Offset(50, 50)), isTrue);
      expect(shape.contains(const Offset(53, 47)), isTrue); // Near middle
      expect(shape.contains(const Offset(0, 0)), isTrue);
      expect(shape.contains(const Offset(100, 100)), isTrue);
      expect(shape.contains(const Offset(107, 107)), isFalse); // Past end
      expect(shape.contains(const Offset(20, 80)), isFalse); // Far from line
    });

    test('RectangleShape contains point', () {
      const shape = RectangleShape(
        start: Offset(10, 10),
        end: Offset(50, 50),
        strokeColor: Color(0xFF000000),
        strokeWidth: 2,
      );

      expect(shape.contains(const Offset(30, 30)), isTrue);
      expect(shape.contains(const Offset(10, 10)), isTrue);
      expect(shape.contains(const Offset(50, 50)), isTrue);
      expect(shape.contains(const Offset(5, 5)), isFalse);
      expect(shape.contains(const Offset(55, 30)), isFalse);
    });

    test('CircleShape contains point', () {
      const shape = CircleShape(
        start: Offset(0, 0),
        end: Offset(20, 20), // Radius 10, center (10, 10)
        strokeColor: Color(0xFF000000),
        strokeWidth: 2,
      );

      expect(shape.contains(const Offset(10, 10)), isTrue);
      expect(shape.contains(const Offset(15, 15)), isTrue);
      expect(shape.contains(const Offset(2, 2)), isFalse); // Corner of bounding box but not in circle
    });

    test('EllipseShape contains point', () {
      const shape = EllipseShape(
        start: Offset(0, 0),
        end: Offset(100, 50), // Center (50, 25), a=50, b=25
        strokeColor: Color(0xFF000000),
        strokeWidth: 2,
      );

      expect(shape.contains(const Offset(50, 25)), isTrue);
      expect(shape.contains(const Offset(90, 25)), isTrue);
      expect(shape.contains(const Offset(50, 45)), isTrue);
      expect(shape.contains(const Offset(5, 5)), isFalse);
    });

    test('PointShape contains point', () {
      const shape = PointShape(
        center: Offset(50, 50),
        strokeColor: Color(0xFF000000),
        strokeWidth: 20, // radius 10
      );

      expect(shape.contains(const Offset(50, 50)), isTrue);
      expect(shape.contains(const Offset(55, 55)), isTrue);
      expect(shape.contains(const Offset(65, 65)), isFalse);
    });
  });

  group('CanvasState.findShapeAt', () {
    test('detects top-most shape', () {
      final state = CanvasState();
      
      const bottom = RectangleShape(
        start: Offset(0, 0),
        end: Offset(100, 100),
        strokeColor: Color(0xFFFF0000),
        strokeWidth: 2,
      );
      
      const top = RectangleShape(
        start: Offset(50, 50),
        end: Offset(150, 150),
        strokeColor: Color(0xFF0000FF),
        strokeWidth: 2,
      );

      state.addShape(bottom);
      state.addShape(top);

      // Point (75, 75) is in both, but top is dominant
      expect(state.findShapeAt(const Offset(75, 75)), top);
      
      // Point (25, 25) is only in bottom
      expect(state.findShapeAt(const Offset(25, 25)), bottom);
      
      // Point (125, 125) is only in top
      expect(state.findShapeAt(const Offset(125, 125)), top);
      
      // Point (200, 200) is in neither
      expect(state.findShapeAt(const Offset(200, 200)), isNull);
    });
  });
}
