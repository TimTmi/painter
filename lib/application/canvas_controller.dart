import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:paint/application/canvas_state.dart';
import 'package:paint/application/tool_controller.dart';
import 'package:paint/application/shape_factory.dart';

class CanvasController extends ChangeNotifier {
  CanvasController({
    required this.canvasState,
    required this.toolController,
  });

  final CanvasState canvasState;
  final ToolController toolController;

  Offset? _startPoint;

  void onPointerDown(Offset localPosition) {
    _startPoint = localPosition;
    _updatePreview(localPosition);
  }

  void onPointerMove(Offset localPosition) {
    _updatePreview(localPosition);
  }

  void onPointerUp(Offset localPosition) {
    _commitShape(localPosition);
    _startPoint = null;
  }

  void _updatePreview(Offset currentPoint) {
    final start = _startPoint;
    if (start == null) return;

    final shape = ShapeFactory.create(
      toolType: toolController.selectedTool,
      start: start,
      end: currentPoint,
      // Color and strokeWidth should ideally come from ToolController or another state
      // For now, using defaults as seen in ShapeFactory or hardcoded
    );

    canvasState.updatePreview(shape);
  }

  void _commitShape(Offset endPoint) {
    final start = _startPoint;
    if (start == null) return;

    final shape = ShapeFactory.create(
      toolType: toolController.selectedTool,
      start: start,
      end: endPoint,
    );

    canvasState.addShape(shape);
    canvasState.updatePreview(null);
  }
}
