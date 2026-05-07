import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:paint/main.dart';
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

    await tester.pumpWidget(
      ToolbarTestHost(
        onSave: () => savePressed = true,
        onLoad: () => loadPressed = true,
      ),
    );

    await tester.tap(find.byTooltip('Save'));
    await tester.tap(find.byTooltip('Load'));

    expect(savePressed, true);
    expect(loadPressed, true);
  });

  testWidgets('Painter screen shows save and load buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byTooltip('Save'), findsOneWidget);
    expect(find.byTooltip('Load'), findsOneWidget);
  });

  testWidgets('Painter screen wires save and load button actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Save'));
    await tester.pump();
    expect(find.text('Save file'), findsOneWidget);

    await tester.tap(find.byTooltip('Load'));
    await tester.pump();
    expect(find.text('Load file'), findsOneWidget);
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
  const ToolbarTestHost({super.key, this.onSave, this.onLoad});

  final VoidCallback? onSave;
  final VoidCallback? onLoad;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Toolbar(onSave: onSave, onLoad: onLoad),
      ),
    );
  }
}
