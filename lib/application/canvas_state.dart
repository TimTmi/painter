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

  void clear() {
    if (_shapes.isEmpty && _previewShape == null) {
      return;
    }

    _shapes.clear();
    _previewShape = null;
    notifyListeners();
  }
}
