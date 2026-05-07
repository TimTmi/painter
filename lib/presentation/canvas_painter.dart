import 'package:flutter/material.dart';
import 'package:paint/application/canvas_state.dart';

class CanvasPainter extends CustomPainter {
  CanvasPainter({required this.state}) : super(repaint: state);

  final CanvasState state;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final shape in state.shapes) {
      shape.draw(canvas, size, paint);
    }

    final preview = state.previewShape;
    if (preview != null) {
      preview.draw(canvas, size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) {
    return oldDelegate.state != state;
  }
}
