import 'package:flutter/material.dart';
import 'package:paint/application/drawing_controller.dart';
import 'package:paint/presentation/widgets/canvas_area.dart';
import 'package:paint/presentation/widgets/toolbar.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final DrawingController _drawingController = DrawingController();

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  void _handleCanvasDragChanged(CanvasDragState dragState) {
    switch (dragState.phase) {
      case CanvasDragPhase.start:
        _drawingController.startDrawing(dragState.startPoint);
        break;
      case CanvasDragPhase.update:
        _drawingController.updateDrawing(dragState.currentPoint);
        break;
      case CanvasDragPhase.end:
        _drawingController.endDrawing();
        break;
      case CanvasDragPhase.cancel:
        _drawingController.cancelDrawing();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painter')),
      body: Column(
        children: [
          const Toolbar(),
          Expanded(child: CanvasArea(onDragChanged: _handleCanvasDragChanged)),
          AnimatedBuilder(
            animation: _drawingController,
            builder: (context, child) {
              final startPoint = _drawingController.startPoint;
              final currentPoint = _drawingController.currentPoint;

              if (startPoint == null || currentPoint == null) {
                return const _PointStatus(text: 'Drag on canvas');
              }

              return _PointStatus(
                text:
                    'start: ${_formatOffset(startPoint)} | current: ${_formatOffset(currentPoint)} | drawing: ${_drawingController.isDrawing}',
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatOffset(Offset offset) {
    return '(${offset.dx.toStringAsFixed(1)}, ${offset.dy.toStringAsFixed(1)})';
  }
}

class _PointStatus extends StatelessWidget {
  const _PointStatus({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
