import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:paint/application/canvas_state.dart';
import 'package:paint/application/shape_factory.dart';
import 'package:paint/application/tool_controller.dart';

class DrawingController extends ChangeNotifier {
  DrawingController({
    required CanvasState canvasState,
    required ToolController toolController,
  }) : _canvasState = canvasState,
       _toolController = toolController;

  final CanvasState _canvasState;
  final ToolController _toolController;

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
    _updatePreview();
    notifyListeners();
  }

  void updateDrawing(Offset point) {
    if (!_isDrawing) {
      return;
    }

    _currentPoint = point;
    _updatePreview();
    notifyListeners();
  }

  void endDrawing() {
    final startPoint = _startPoint;
    final currentPoint = _currentPoint;

    if (!_isDrawing || startPoint == null || currentPoint == null) {
      return;
    }

    final shape = ShapeFactory.create(
      toolType: _toolController.selectedTool,
      start: startPoint,
      end: currentPoint,
      strokeColor: _toolController.strokeColor,
      strokeWidth: _toolController.strokeWidth,
    );

    _canvasState.addShape(shape);
    _canvasState.updatePreview(null);
    _isDrawing = false;
    notifyListeners();
  }

  void cancelDrawing() {
    if (!_isDrawing) {
      return;
    }

    _canvasState.updatePreview(null);
    _isDrawing = false;
    notifyListeners();
  }

  void clearPoints() {
    _startPoint = null;
    _currentPoint = null;
    _isDrawing = false;
    _canvasState.updatePreview(null);
    notifyListeners();
  }

  void _updatePreview() {
    final startPoint = _startPoint;
    final currentPoint = _currentPoint;

    if (!_isDrawing || startPoint == null || currentPoint == null) {
      _canvasState.updatePreview(null);
      return;
    }

    final previewShape = ShapeFactory.create(
      toolType: _toolController.selectedTool,
      start: startPoint,
      end: currentPoint,
      strokeColor: _toolController.strokeColor,
      strokeWidth: _toolController.strokeWidth,
    );

    _canvasState.updatePreview(previewShape);
  }
}
