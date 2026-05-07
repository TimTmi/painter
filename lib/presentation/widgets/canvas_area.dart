import 'package:flutter/material.dart';
import 'package:paint/application/canvas_state.dart';
import 'package:paint/painters/canvas_painter.dart';

enum CanvasDragPhase { start, update, end, cancel }

class CanvasDragState {
  const CanvasDragState({
    required this.startPoint,
    required this.currentPoint,
    required this.phase,
    required this.isDragging,
  });

  final Offset startPoint;
  final Offset currentPoint;
  final CanvasDragPhase phase;
  final bool isDragging;
}

class CanvasArea extends StatefulWidget {
  const CanvasArea({
    super.key,
    required this.canvasState,
    this.onDragChanged,
    this.onTap,
  });

  final CanvasState canvasState;
  final ValueChanged<CanvasDragState>? onDragChanged;
  final ValueChanged<Offset>? onTap;

  @override
  State<CanvasArea> createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasArea> {
  Offset? _startPoint;
  Offset? _currentPoint;

  void _emitDragState({
    required CanvasDragPhase phase,
    required bool isDragging,
  }) {
    final startPoint = _startPoint;
    final currentPoint = _currentPoint;

    if (startPoint == null || currentPoint == null) {
      return;
    }

    widget.onDragChanged?.call(
      CanvasDragState(
        startPoint: startPoint,
        currentPoint: currentPoint,
        phase: phase,
        isDragging: isDragging,
      ),
    );
  }

  void _handlePanStart(DragStartDetails details) {
    _startPoint = details.localPosition;
    _currentPoint = details.localPosition;
    _emitDragState(phase: CanvasDragPhase.start, isDragging: true);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    _currentPoint = details.localPosition;
    _emitDragState(phase: CanvasDragPhase.update, isDragging: true);
  }

  void _handlePanEnd(DragEndDetails details) {
    _emitDragState(phase: CanvasDragPhase.end, isDragging: false);
  }

  void _handlePanCancel() {
    _emitDragState(phase: CanvasDragPhase.cancel, isDragging: false);
  }

  void _handleTapUp(TapUpDetails details) {
    widget.onTap?.call(details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onPanCancel: _handlePanCancel,
      onTapUp: _handleTapUp,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: CanvasPainter(canvasState: widget.canvasState),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
