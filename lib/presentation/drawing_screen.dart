import 'package:flutter/material.dart';
import 'package:paint/application/canvas_controller.dart';
import 'package:paint/application/canvas_state.dart';
import 'package:paint/application/tool_controller.dart';
import 'package:paint/presentation/widgets/canvas_area.dart';
import 'package:paint/presentation/widgets/toolbar.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  late final CanvasState _canvasState;
  late final ToolController _toolController;
  late final CanvasController _canvasController;

  @override
  void initState() {
    super.initState();
    _canvasState = CanvasState();
    _toolController = ToolController();
    _canvasController = CanvasController(
      canvasState: _canvasState,
      toolController: _toolController,
    );
  }

  @override
  void dispose() {
    _canvasState.dispose();
    _toolController.dispose();
    _canvasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painter')),
      body: Column(
        children: [
          Toolbar(controller: _toolController),
          Expanded(
            child: CanvasArea(controller: _canvasController),
          ),
          ListenableBuilder(
            listenable: _canvasController,
            builder: (context, child) {
              return _StatusFooter(
                toolName: _toolController.selectedTool.name,
                shapeCount: _canvasState.shapes.length,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatusFooter extends StatelessWidget {
  const _StatusFooter({
    required this.toolName,
    required this.shapeCount,
  });

  final String toolName;
  final int shapeCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Text(
        'Tool: ${toolName.toUpperCase()} | Shapes: $shapeCount',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
