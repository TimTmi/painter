import 'package:flutter/material.dart';
import 'package:paint/application/canvas_controller.dart';
import 'package:paint/presentation/canvas_painter.dart';

class CanvasArea extends StatelessWidget {
  const CanvasArea({super.key, required this.controller});

  final CanvasController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (details) => controller.onPointerDown(details.localPosition),
      onPanUpdate: (details) => controller.onPointerMove(details.localPosition),
      onPanEnd: (details) => controller.onPointerUp(details.localPosition),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: CanvasPainter(state: controller.canvasState),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
