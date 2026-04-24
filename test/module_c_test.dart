import 'package:flutter_test/flutter_test.dart';
import 'package:paint/application/canvas_state.dart';
import 'package:paint/application/tool_controller.dart';
import 'package:paint/application/tool_type.dart';
import 'package:paint/domain/shapes/shape.dart';

class MockShape extends Shape {}

void main() {
  group('Module C Verification', () {
    test('ToolController should switch tools and notify listeners', () {
      final controller = ToolController();
      var notified = false;
      controller.addListener(() => notified = true);

      expect(controller.selectedTool, ToolType.line);
      
      controller.setTool(ToolType.rectangle);
      expect(controller.selectedTool, ToolType.rectangle);
      expect(notified, true);
    });

    test('CanvasState should manage shapes and notify listeners', () {
      final state = CanvasState();
      var notified = false;
      state.addListener(() => notified = true);

      expect(state.shapes.isEmpty, true);
      
      final shape = MockShape();
      state.addShape(shape);
      
      expect(state.shapes.length, 1);
      expect(state.shapes[0], shape);
      expect(notified, true);
    });

    test('CanvasState should manage preview shape', () {
      final state = CanvasState();
      var notified = false;
      state.addListener(() => notified = true);

      expect(state.previewShape, isNull);
      
      final shape = MockShape();
      state.updatePreview(shape);
      
      expect(state.previewShape, shape);
      expect(notified, true);
      
      state.updatePreview(null);
      expect(state.previewShape, isNull);
    });
  });
}
