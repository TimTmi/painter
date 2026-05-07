import 'package:flutter/material.dart';
import 'package:paint/application/canvas_state.dart';

class CanvasPainter extends CustomPainter {
  CanvasPainter({required this.canvasState}) : super(repaint: canvasState);

  final CanvasState canvasState;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    for (final shape in canvasState.shapes) {
      shape.draw(canvas);
    }

    canvasState.previewShape?.draw(canvas);

    final borderPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(Offset.zero & size, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) {
    return oldDelegate.canvasState != canvasState;
  }
}
