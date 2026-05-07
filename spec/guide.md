# Guide

## Ý tưởng chính

Canvas giữ danh sách shape, không bitmap.

```text
Canvas
├─ shapes (các shape đã vẽ)
└─ previewShape (shape đang kéo chuột)
```

Quy trình vẽ:

```text
shapes
↓
previewShape
↓
CustomPainter
↓
vẽ lên màn hình
```

Khi người dùng kết thúc thao tác:

```text
previewShape → shapes
```

Không merge raster. Không xử lý pixel.

## Pipeline render

Luồng xử lý:

```text
User input
↓
Tool logic
↓
Update state (shapes / preview)
↓
setState / notifyListeners
↓
CustomPainter repaint
```

Painter vẽ:

```dart
for (final shape in shapes) {
  shape.draw(canvas);
}

if (previewShape != null) {
  previewShape.draw(canvas);
}
```

## Model trạng thái canvas

```dart
class CanvasState {
  List<Shape> shapes;
  Shape? previewShape;
}
```

Ý nghĩa:

- `shapes`: phần đã vẽ xong.
- `previewShape`: hình đang kéo chuột.

State management: `setState` hoặc `ChangeNotifier`.

## Hệ shape

Base class:

```dart
abstract class Shape {
  Color strokeColor;
  Color fillColor;
  double strokeWidth;

  void draw(Canvas canvas, Size size, Paint paint);
}
```

API Flutter dùng:

- `Canvas`
- `Paint`
- `Rect`
- `Path`

Các shape:

- `LineShape`
- `RectangleShape`
- `SquareShape`
- `CircleShape`
- `EllipseShape`
- `PointShape`

Ví dụ `LineShape`:

```dart
class LineShape extends Shape {
  Offset start;
  Offset end;

  @override
  void draw(Canvas canvas, Size size, Paint paint) {
    paint
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }
}
```

## Hệ tool

Enum tool:

```dart
enum ToolType {
  point,
  line,
  rectangle,
  square,
  circle,
  ellipse,
}
```

Hành vi:

- Nhấn → `startPoint`
- Kéo → update `previewShape`
- Nhả → commit shape

## Vẽ shape

Sử dụng `GestureDetector`.

Input events:

- `onPointerDown`
- `onPointerMove`
- `onPointerUp`

Luồng:

```dart
onPanStart(details) {
  start = details.localPosition;
}

onPanUpdate(details) {
  current = details.localPosition;
  previewShape = buildShape(start, current);
  notifyListeners();
}

onPanEnd(_) {
  shapes.add(previewShape);
  previewShape = null;
  notifyListeners();
}
```

## CustomPainter

Renderer chính:

```dart
class CanvasPainter extends CustomPainter {
  final CanvasState state;

  CanvasPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final shape in state.shapes) {
      shape.draw(canvas, size, paint);
    }

    state.previewShape?.draw(canvas, size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
```

## Xuất ảnh

Pipeline:

```text
RenderRepaintBoundary
↓
toImage()
↓
encode PNG/JPEG
```

Flutter:

```dart
final boundary = globalKey.currentContext!.findRenderObject()
    as RenderRepaintBoundary;

final image = await boundary.toImage();
final byteData = await image.toByteData(format: ImageByteFormat.png);
```

Format hỗ trợ:

- PNG
- JPEG

## Lưu file nhị phân

Format vector:

```text
header
shapeCount
shapes...
```

Encode shape:

```text
[type]
[strokeWidth]
[strokeColor]
[fillColor]
[points...]
```
