import 'dart:ui';

import 'package:flutter/foundation.dart';

class DrawingController extends ChangeNotifier {
  Offset? _startPoint;
  Offset? _currentPoint;
  bool _isDrawing = false;

  Offset? get startPoint => _startPoint;
  Offset? get currentPoint => _currentPoint;
  bool get isDrawing => _isDrawing;

  void startDrawing(Offset point) {
    _startPoint = point;
    _currentPoint = point;
    _isDrawing = true;
    notifyListeners();
  }

  void updateDrawing(Offset point) {
    if (!_isDrawing) {
      return;
    }

    _currentPoint = point;
    notifyListeners();
  }

  void endDrawing() {
    if (!_isDrawing) {
      return;
    }

    _isDrawing = false;
    notifyListeners();
  }

  void cancelDrawing() {
    endDrawing();
  }

  void clearPoints() {
    _startPoint = null;
    _currentPoint = null;
    _isDrawing = false;
    notifyListeners();
  }
}
