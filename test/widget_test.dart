import 'package:flutter_test/flutter_test.dart';

import 'package:paint/main.dart';
import 'package:paint/presentation/widgets/canvas_area.dart';

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
