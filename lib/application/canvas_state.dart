import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:paint/domain/shapes/shape.dart';

class CanvasState extends ChangeNotifier {
  final List<Shape> _shapes = [];
  Shape? _previewShape;

  List<Shape> get shapes => List.unmodifiable(_shapes);
  Shape? get previewShape => _previewShape;

  void addShape(Shape shape) {
    _shapes.add(shape);
    notifyListeners();
  }

  void updatePreview(Shape? shape) {
    _previewShape = shape;
    notifyListeners();
  }

  void clear() {
    _shapes.clear();
    _previewShape = null;
    notifyListeners();
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
