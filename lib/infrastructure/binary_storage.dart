import 'dart:typed_data';
import 'dart:ui';

import 'package:paint/domain/shapes/circle.dart';
import 'package:paint/domain/shapes/ellipse.dart';
import 'package:paint/domain/shapes/line.dart';
import 'package:paint/domain/shapes/point.dart';
import 'package:paint/domain/shapes/rectangle.dart';
import 'package:paint/domain/shapes/shape.dart';
import 'package:paint/domain/shapes/square.dart';

class BinaryStorageException implements Exception {
  const BinaryStorageException(this.message);

  final String message;

  @override
  String toString() => 'BinaryStorageException: $message';
}

class BinaryStorage {
  const BinaryStorage._();

  static const fileExtension = 'pnt';
  static const defaultFileName = 'drawing.$fileExtension';

  static const _magic = [0x50, 0x4E, 0x54, 0x52]; // PNTR
  static const _version = 1;

  static Uint8List encodeShapes(Iterable<Shape> shapes) {
    final shapeList = List<Shape>.unmodifiable(shapes);
    final writer = _BinaryWriter()
      ..addBytes(_magic)
      ..addUint8(_version)
      ..addUint32(shapeList.length);

    for (final shape in shapeList) {
      final record = _ShapeRecord.fromShape(shape);
      writer
        ..addUint8(record.type.id)
        ..addFloat64(shape.strokeWidth)
        ..addUint32(shape.strokeColor.toARGB32())
        ..addUint32(shape.fillColor.toARGB32())
        ..addOffset(record.start)
        ..addOffset(record.end);
    }

    return writer.toBytes();
  }

  static List<Shape> decodeShapes(Uint8List bytes) {
    final reader = _BinaryReader(bytes);

    for (final expected in _magic) {
      final actual = reader.readUint8();
      if (actual != expected) {
        throw const BinaryStorageException('Invalid painter file header');
      }
    }

    final version = reader.readUint8();
    if (version != _version) {
      throw BinaryStorageException(
        'Unsupported painter file version: $version',
      );
    }

    final shapeCount = reader.readUint32();
    final shapes = <Shape>[];

    for (var i = 0; i < shapeCount; i++) {
      final type = _StoredShapeType.fromId(reader.readUint8());
      final strokeWidth = reader.readFloat64();
      final strokeColor = Color(reader.readUint32());
      final fillColor = Color(reader.readUint32());
      final start = reader.readOffset();
      final end = reader.readOffset();

      shapes.add(
        type.toShape(
          start: start,
          end: end,
          strokeColor: strokeColor,
          fillColor: fillColor,
          strokeWidth: strokeWidth,
        ),
      );
    }

    if (!reader.isDone) {
      throw const BinaryStorageException('Unexpected trailing bytes');
    }

    return shapes;
  }
}

enum _StoredShapeType {
  point(1),
  line(2),
  rectangle(3),
  square(4),
  circle(5),
  ellipse(6);

  const _StoredShapeType(this.id);

  final int id;

  static _StoredShapeType fromId(int id) {
    for (final type in values) {
      if (type.id == id) {
        return type;
      }
    }

    throw BinaryStorageException('Unknown shape type id: $id');
  }

  Shape toShape({
    required Offset start,
    required Offset end,
    required Color strokeColor,
    required Color fillColor,
    required double strokeWidth,
  }) {
    return switch (this) {
      _StoredShapeType.point => PointShape(
        center: start,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
      _StoredShapeType.line => LineShape(
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
      _StoredShapeType.rectangle => RectangleShape(
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
      _StoredShapeType.square => SquareShape(
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
      _StoredShapeType.circle => CircleShape(
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
      _StoredShapeType.ellipse => EllipseShape(
        start: start,
        end: end,
        strokeColor: strokeColor,
        fillColor: fillColor,
        strokeWidth: strokeWidth,
      ),
    };
  }
}

class _ShapeRecord {
  const _ShapeRecord({
    required this.type,
    required this.start,
    required this.end,
  });

  final _StoredShapeType type;
  final Offset start;
  final Offset end;

  factory _ShapeRecord.fromShape(Shape shape) {
    return switch (shape) {
      PointShape(:final center) => _ShapeRecord(
        type: _StoredShapeType.point,
        start: center,
        end: center,
      ),
      LineShape(:final start, :final end) => _ShapeRecord(
        type: _StoredShapeType.line,
        start: start,
        end: end,
      ),
      RectangleShape(:final start, :final end) => _ShapeRecord(
        type: _StoredShapeType.rectangle,
        start: start,
        end: end,
      ),
      SquareShape(:final start, :final end) => _ShapeRecord(
        type: _StoredShapeType.square,
        start: start,
        end: end,
      ),
      CircleShape(:final start, :final end) => _ShapeRecord(
        type: _StoredShapeType.circle,
        start: start,
        end: end,
      ),
      EllipseShape(:final start, :final end) => _ShapeRecord(
        type: _StoredShapeType.ellipse,
        start: start,
        end: end,
      ),
      _ => throw BinaryStorageException(
        'Unsupported shape class: ${shape.runtimeType}',
      ),
    };
  }
}

class _BinaryWriter {
  final BytesBuilder _builder = BytesBuilder(copy: false);

  void addBytes(List<int> bytes) {
    _builder.add(bytes);
  }

  void addUint8(int value) {
    _builder.add([value]);
  }

  void addUint32(int value) {
    final bytes = ByteData(4)..setUint32(0, value, Endian.little);
    _builder.add(bytes.buffer.asUint8List());
  }

  void addFloat64(double value) {
    final bytes = ByteData(8)..setFloat64(0, value, Endian.little);
    _builder.add(bytes.buffer.asUint8List());
  }

  void addOffset(Offset offset) {
    addFloat64(offset.dx);
    addFloat64(offset.dy);
  }

  Uint8List toBytes() => _builder.toBytes();
}

class _BinaryReader {
  _BinaryReader(this._bytes);

  final Uint8List _bytes;
  int _offset = 0;

  bool get isDone => _offset == _bytes.length;

  int readUint8() {
    _ensureAvailable(1);
    return _bytes[_offset++];
  }

  int readUint32() {
    final data = _readByteData(4);
    return data.getUint32(0, Endian.little);
  }

  double readFloat64() {
    final data = _readByteData(8);
    return data.getFloat64(0, Endian.little);
  }

  Offset readOffset() {
    return Offset(readFloat64(), readFloat64());
  }

  ByteData _readByteData(int length) {
    _ensureAvailable(length);
    final data = ByteData.sublistView(_bytes, _offset, _offset + length);
    _offset += length;
    return data;
  }

  void _ensureAvailable(int length) {
    if (_offset + length > _bytes.length) {
      throw const BinaryStorageException('Unexpected end of painter file');
    }
  }
}
