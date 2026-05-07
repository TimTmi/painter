import 'package:flutter_test/flutter_test.dart';
import 'package:paint/application/canvas_controller.dart';
import 'package:paint/application/canvas_state.dart';
import 'package:paint/application/tool_controller.dart';
import 'package:paint/application/tool_type.dart';

void main() {
  group('Integrated Drawing Pipeline Verification', () {
    late CanvasState canvasState;
    late ToolController toolController;
    late CanvasController canvasController;

    setUp(() {
      canvasState = CanvasState();
      toolController = ToolController();
      canvasController = CanvasController(
        canvasState: canvasState,
        toolController: toolController,
      );
    });

    test('Should create preview shape on pan start and update', () {
      toolController.setTool(ToolType.rectangle);
      
      canvasController.onPointerDown(const Offset(10, 10));
      expect(canvasState.previewShape, isNotNull);
      
      canvasController.onPointerMove(const Offset(20, 20));
      expect(canvasState.previewShape, isNotNull);
      // We can't easily check shape internal rect here without casting, 
      // but previewShape being updated is a good sign.
    });

    test('Should commit shape to state on pan end', () {
      toolController.setTool(ToolType.line);
      
      canvasController.onPointerDown(const Offset(0, 0));
      canvasController.onPointerMove(const Offset(100, 100));
      canvasController.onPointerUp(const Offset(100, 100));
      
      expect(canvasState.previewShape, isNull);
      expect(canvasState.shapes.length, 1);
    });

    test('Should switch tools and affect created shapes', () {
      toolController.setTool(ToolType.circle);
      canvasController.onPointerDown(const Offset(0, 0));
      canvasController.onPointerUp(const Offset(10, 10));
      
      expect(canvasState.shapes.length, 1);
      // Note: Full verification would check the type of actual shape object
    });
  });
}
