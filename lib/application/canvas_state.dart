import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:paint/domain/shapes/shape.dart';

class CanvasState extends ChangeNotifier {
  final List<Shape> _shapes = [];
  Shape? _previewShape;

  List<Shape> get shapes => List.unmodifiable(_shapes);
  Shape? get previewShape => _previewShape;
  bool get canUndo => _shapes.isNotEmpty;

  void addShape(Shape shape) {
    _shapes.add(shape);
    notifyListeners();
  }

  void commitShape(Shape shape) {
    _shapes.add(shape);
    _previewShape = null;
    notifyListeners();
  }

  void updatePreview(Shape? shape) {
    if (_previewShape == shape) {
      return;
    }

    _previewShape = shape;
    notifyListeners();
  }

  void undoLastShape() {
    if (_shapes.isEmpty) {
      return;
    }

    _shapes.removeLast();
    _previewShape = null;
    notifyListeners();
  }

  void replaceShapes(Iterable<Shape> shapes) {
    _shapes
      ..clear()
      ..addAll(shapes);
    _previewShape = null;
    notifyListeners();
  }

  void clear() {
    if (_shapes.isEmpty && _previewShape == null) {
      return;
    }

    _shapes.clear();
    _previewShape = null;
    notifyListeners();
  }

  void replaceShape(Shape oldShape, Shape newShape) {
    final index = _shapes.indexOf(oldShape);
    if (index == -1) return;
    _shapes[index] = newShape;
    notifyListeners();
  }

  void removeShape(Shape shape) {
    if (_shapes.remove(shape)) {
      notifyListeners();
    }
  }

  Shape? findShapeAt(Offset point) {
    for (var i = _shapes.length - 1; i >= 0; i--) {
      if (_shapes[i].contains(point)) {
        return _shapes[i];
      }
    }
    return null;
  }
}
