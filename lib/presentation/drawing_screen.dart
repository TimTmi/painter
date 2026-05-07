import 'dart:async';

import 'package:flutter/material.dart';
import 'package:paint/application/canvas_state.dart';
import 'package:paint/application/drawing_controller.dart';
import 'package:paint/application/tool_controller.dart';
import 'package:paint/infrastructure/image_export.dart';
import 'package:paint/infrastructure/binary_file_service.dart';
import 'package:paint/presentation/widgets/canvas_area.dart';
import 'package:paint/presentation/widgets/toolbar.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({
    super.key,
    this.binaryFileService = const FilePickerBinaryFileService(),
  });

  final BinaryFileService binaryFileService;

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final CanvasState _canvasState = CanvasState();
  final ToolController _toolController = ToolController();
  final ImageExport _imageExport = ImageExport();
  final GlobalKey _canvasRepaintBoundaryKey = GlobalKey(
    debugLabel: 'canvas-repaint-boundary',
  );
  late final DrawingController _drawingController = DrawingController(
    canvasState: _canvasState,
    toolController: _toolController,
  );

  @override
  void dispose() {
    _drawingController.dispose();
    _toolController.dispose();
    _canvasState.dispose();
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

  void _handleSavePressed() {
    unawaited(_saveDrawing());
  }

  void _handleLoadPressed() {
    unawaited(_loadDrawing());
  }

  Future<void> _saveDrawing() async {
    try {
      final saved = await widget.binaryFileService.saveShapes(
        _canvasState.shapes,
      );
      _showFileActionMessage(saved ? 'Saved painter file' : 'Save cancelled');
    } on Object catch (error) {
      _showFileActionMessage('Save failed: $error');
    }
  }

  Future<void> _loadDrawing() async {
    try {
      final shapes = await widget.binaryFileService.loadShapes();
      if (shapes == null) {
        _showFileActionMessage('Load cancelled');
        return;
      }

      _drawingController.clearPoints();
      _canvasState.replaceShapes(shapes);
      _showFileActionMessage('Loaded ${shapes.length} shape(s)');
    } on Object catch (error) {
      _showFileActionMessage('Load failed: $error');
    }
  }

  Future<void> _handleExportImagePressed() async {
    try {
      final filePath = await _imageExport.exportPng(
        repaintBoundaryKey: _canvasRepaintBoundaryKey,
      );

      if (!mounted) {
        return;
      }

      _showFileActionMessage('Image exported: $filePath');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showFileActionMessage('Export failed: $error');
    }
  }

  void _showFileActionMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleCanvasTap(Offset point) {
    _drawingController.applyTool(point);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painter')),
      body: Column(
        children: [
          Toolbar(
            toolController: _toolController,
            onSave: _handleSavePressed,
            onLoad: _handleLoadPressed,
            onExportImage: _handleExportImagePressed,
          ),
          Expanded(
            child: CanvasArea(
              canvasState: _canvasState,
              onDragChanged: _handleCanvasDragChanged,
              repaintBoundaryKey: _canvasRepaintBoundaryKey,
              onTap: _handleCanvasTap,
            ),
          ),
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
