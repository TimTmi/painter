import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paint/application/canvas_state.dart';
import 'package:paint/application/tool_controller.dart';
import 'package:paint/application/tool_type.dart';
import 'package:paint/domain/shapes/line.dart';
import 'package:paint/domain/shapes/rectangle.dart';
import 'package:paint/domain/shapes/shape.dart';

class MockShape extends Shape {
  const MockShape()
    : super(
        strokeColor: const Color(0xFF000000),
        fillColor: const Color(0x00000000),
        strokeWidth: 1,
      );

  @override
  void draw(Canvas canvas) {}
}

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

      const shape = MockShape();
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

      const shape = MockShape();
      state.updatePreview(shape);

      expect(state.previewShape, shape);
      expect(notified, true);

      state.updatePreview(null);
      expect(state.previewShape, isNull);
    });

    test('CanvasState should undo the latest shape', () {
      final state = CanvasState();
      var notifyCount = 0;
      state.addListener(() => notifyCount++);

      const firstShape = MockShape();
      const secondShape = MockShape();

      state.addShape(firstShape);
      state.addShape(secondShape);

      expect(state.canUndo, true);
      expect(state.shapes, [firstShape, secondShape]);

      state.undoLastShape();

      expect(state.shapes, [firstShape]);
      expect(state.previewShape, isNull);
      expect(notifyCount, 3);
    });

    test('CanvasState should commit shape and clear preview in one update', () {
      final state = CanvasState();
      var notifyCount = 0;
      state.addListener(() => notifyCount++);

      const previewShape = MockShape();
      const finalShape = MockShape();

      state.updatePreview(previewShape);
      state.commitShape(finalShape);

      expect(state.shapes, [finalShape]);
      expect(state.previewShape, isNull);
      expect(notifyCount, 2);
    });

    test('LineShape should expose drawing contract properties', () {
      const shape = LineShape(
        start: Offset(0, 0),
        end: Offset(10, 20),
        strokeColor: Color(0xFFFF0000),
        strokeWidth: 2,
      );

      expect(shape.start, const Offset(0, 0));
      expect(shape.end, const Offset(10, 20));
      expect(shape.strokeColor, const Color(0xFFFF0000));
      expect(shape.fillColor, const Color(0x00000000));
      expect(shape.strokeWidth, 2);
    });

    test('RectangleShape should expose drawing contract properties', () {
      const shape = RectangleShape(
        start: Offset(20, 30),
        end: Offset(10, 5),
        strokeColor: Color(0xFF00FF00),
        fillColor: Color(0x3300FF00),
        strokeWidth: 3,
      );

      expect(shape.rect, const Rect.fromLTRB(10, 5, 20, 30));
      expect(shape.strokeColor, const Color(0xFF00FF00));
      expect(shape.fillColor, const Color(0x3300FF00));
      expect(shape.strokeWidth, 3);
    });
  });
}
