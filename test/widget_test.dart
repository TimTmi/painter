import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paint/domain/shapes/line.dart';
import 'package:paint/domain/shapes/shape.dart';
import 'package:paint/infrastructure/binary_file_service.dart';

import 'package:paint/main.dart';
import 'package:paint/presentation/drawing_screen.dart';
import 'package:paint/presentation/widgets/canvas_area.dart';
import 'package:paint/presentation/widgets/toolbar.dart';

void main() {
  testWidgets('Painter starts with canvas screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Painter'), findsOneWidget);
    expect(find.text('Drag on canvas'), findsOneWidget);
  });

  testWidgets('Toolbar exposes the full shape tool set', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byTooltip('Point'), findsOneWidget);
    expect(find.byTooltip('Line'), findsOneWidget);
    expect(find.byTooltip('Rect'), findsOneWidget);
    expect(find.byTooltip('Square'), findsOneWidget);
    expect(find.byTooltip('Circle'), findsOneWidget);
    expect(find.byTooltip('Ellipse'), findsOneWidget);
  });

  testWidgets('Toolbar exposes save and load file actions', (
    WidgetTester tester,
  ) async {
    var savePressed = false;
    var loadPressed = false;
    var undoPressed = false;
    var clearPressed = false;

    await tester.pumpWidget(
      ToolbarTestHost(
        onSave: () => savePressed = true,
        onLoad: () => loadPressed = true,
        onUndo: () => undoPressed = true,
        onClear: () => clearPressed = true,
      ),
    );

    await tester.tap(find.byTooltip('Save'));
    await tester.tap(find.byTooltip('Load'));
    await tester.tap(find.byTooltip('Undo'));
    await tester.tap(find.byTooltip('Clear'));

    expect(savePressed, true);
    expect(loadPressed, true);
    expect(undoPressed, true);
    expect(clearPressed, true);
  });

  testWidgets('Painter screen shows save and load buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byTooltip('Save'), findsOneWidget);
    expect(find.byTooltip('Load'), findsOneWidget);
    expect(find.byTooltip('Undo'), findsOneWidget);
    expect(find.byTooltip('Clear'), findsOneWidget);
  });

  testWidgets('Painter screen wires save and load button actions', (
    WidgetTester tester,
  ) async {
    final fileService = FakeBinaryFileService(
      loadResult: const [
        LineShape(
          start: Offset(0, 0),
          end: Offset(10, 10),
          strokeColor: Color(0xFF000000),
          strokeWidth: 1,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(home: DrawingScreen(binaryFileService: fileService)),
    );

    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();
    expect(fileService.savedShapes, isNotNull);
    expect(find.text('Saved painter file'), findsOneWidget);

    await tester.tap(find.byTooltip('Load'));
    await tester.pumpAndSettle();
    expect(find.text('Loaded 1 shape(s)'), findsOneWidget);
  });

  testWidgets('Canvas emits drag points to status stream', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final center = tester.getCenter(find.byType(CanvasArea));
    final gesture = await tester.startGesture(center);
    await gesture.moveBy(const Offset(20, 30));
    await gesture.up();
    await tester.pump();

    expect(find.textContaining('start:'), findsOneWidget);
    expect(find.textContaining('current:'), findsOneWidget);
    expect(find.textContaining('drawing: false'), findsOneWidget);
  });
}

class ToolbarTestHost extends StatelessWidget {
  const ToolbarTestHost({
    super.key,
    this.onSave,
    this.onLoad,
    this.onUndo,
    this.onClear,
  });

  final VoidCallback? onSave;
  final VoidCallback? onLoad;
  final VoidCallback? onUndo;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Toolbar(
          onSave: onSave,
          onLoad: onLoad,
          onUndo: onUndo,
          onClear: onClear,
        ),
      ),
    );
  }
}

class FakeBinaryFileService implements BinaryFileService {
  FakeBinaryFileService({this.loadResult});

  final List<Shape>? loadResult;
  List<Shape>? savedShapes;

  @override
  Future<bool> saveShapes(Iterable<Shape> shapes) async {
    savedShapes = List<Shape>.unmodifiable(shapes);
    return true;
  }

  @override
  Future<List<Shape>?> loadShapes() async {
    return loadResult;
  }
}
