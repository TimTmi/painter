import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paint/domain/shapes/circle.dart';
import 'package:paint/domain/shapes/ellipse.dart';
import 'package:paint/domain/shapes/line.dart';
import 'package:paint/domain/shapes/point.dart';
import 'package:paint/domain/shapes/rectangle.dart';
import 'package:paint/domain/shapes/shape.dart';
import 'package:paint/domain/shapes/square.dart';
import 'package:paint/infrastructure/binary_storage.dart';

void main() {
  group('BinaryStorage', () {
    test('encodes and decodes an empty drawing', () {
      final bytes = BinaryStorage.encodeShapes(const []);
      final shapes = BinaryStorage.decodeShapes(bytes);

      expect(bytes.take(4), [0x50, 0x4E, 0x54, 0x52]);
      expect(shapes, isEmpty);
    });

    test('round trips the full shape set', () {
      const shapes = <Shape>[
        PointShape(
          center: Offset(1, 2),
          strokeColor: Color(0xFF111111),
          strokeWidth: 3,
        ),
        LineShape(
          start: Offset(3, 4),
          end: Offset(5, 6),
          strokeColor: Color(0xFF222222),
          strokeWidth: 4,
        ),
        RectangleShape(
          start: Offset(7, 8),
          end: Offset(9, 10),
          strokeColor: Color(0xFF333333),
          fillColor: Color(0x44333333),
          strokeWidth: 5,
        ),
        SquareShape(
          start: Offset(11, 12),
          end: Offset(13, 14),
          strokeColor: Color(0xFF444444),
          fillColor: Color(0x44444444),
          strokeWidth: 6,
        ),
        CircleShape(
          start: Offset(15, 16),
          end: Offset(17, 18),
          strokeColor: Color(0xFF555555),
          fillColor: Color(0x44555555),
          strokeWidth: 7,
        ),
        EllipseShape(
          start: Offset(19, 20),
          end: Offset(21, 22),
          strokeColor: Color(0xFF666666),
          fillColor: Color(0x44666666),
          strokeWidth: 8,
        ),
      ];

      final bytes = BinaryStorage.encodeShapes(shapes);
      final decoded = BinaryStorage.decodeShapes(bytes);

      expect(decoded.length, shapes.length);
      _expectSameShape(decoded[0], shapes[0]);
      _expectSameShape(decoded[1], shapes[1]);
      _expectSameShape(decoded[2], shapes[2]);
      _expectSameShape(decoded[3], shapes[3]);
      _expectSameShape(decoded[4], shapes[4]);
      _expectSameShape(decoded[5], shapes[5]);
    });

    test('rejects invalid painter file header', () {
      expect(
        () => BinaryStorage.decodeShapes(Uint8List.fromList([0, 1, 2, 3])),
        throwsA(isA<BinaryStorageException>()),
      );
    });

    test('rejects truncated painter file data', () {
      final bytes = BinaryStorage.encodeShapes([
        const LineShape(
          start: Offset(0, 0),
          end: Offset(1, 1),
          strokeColor: Color(0xFF000000),
          strokeWidth: 1,
        ),
      ]);

      expect(
        () => BinaryStorage.decodeShapes(bytes.sublist(0, bytes.length - 1)),
        throwsA(isA<BinaryStorageException>()),
      );
    });
  });
}

void _expectSameShape(Shape actual, Shape expected) {
  expect(actual.runtimeType, expected.runtimeType);
  expect(actual.strokeColor, expected.strokeColor);
  expect(actual.fillColor, expected.fillColor);
  expect(actual.strokeWidth, expected.strokeWidth);

  switch ((actual, expected)) {
    case (PointShape a, PointShape e):
      expect(a.center, e.center);
    case (LineShape a, LineShape e):
      expect(a.start, e.start);
      expect(a.end, e.end);
    case (RectangleShape a, RectangleShape e):
      expect(a.start, e.start);
      expect(a.end, e.end);
    case (SquareShape a, SquareShape e):
      expect(a.start, e.start);
      expect(a.end, e.end);
    case (CircleShape a, CircleShape e):
      expect(a.start, e.start);
      expect(a.end, e.end);
    case (EllipseShape a, EllipseShape e):
      expect(a.start, e.start);
      expect(a.end, e.end);
    default:
      fail(
        'Unexpected shape pair: ${actual.runtimeType}/${expected.runtimeType}',
      );
  }
}
