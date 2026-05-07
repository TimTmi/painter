import 'dart:async';

import 'package:flutter/material.dart';
import 'package:paint/presentation/widgets/canvas_area.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final StreamController<CanvasDragState> _dragController =
      StreamController<CanvasDragState>.broadcast();

  Stream<CanvasDragState> get dragStream => _dragController.stream;

  @override
  void dispose() {
    _dragController.close();
    super.dispose();
  }

  void _handleCanvasDragChanged(CanvasDragState dragState) {
    _dragController.add(dragState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painter')),
      body: Column(
        children: [
          Expanded(child: CanvasArea(onDragChanged: _handleCanvasDragChanged)),
          StreamBuilder<CanvasDragState>(
            stream: dragStream,
            builder: (context, snapshot) {
              final dragState = snapshot.data;

              if (dragState == null) {
                return const _PointStatus(text: 'Drag on canvas');
              }

              return _PointStatus(
                text:
                    'start: ${_formatOffset(dragState.startPoint)} | current: ${_formatOffset(dragState.currentPoint)} | dragging: ${dragState.isDragging}',
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
