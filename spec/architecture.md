# Architecture

## 1. Tổng quan layer

```text
lib/
├─ presentation/   (UI)
├─ application/    (logic + state)
├─ domain/         (shape + math)
└─ infrastructure/ (file IO + export)
```

Quy tắc:

- UI không logic.
- Domain thuần Dart.
- Application điều phối.
- Infrastructure xử lý file/ảnh.

## 2. Domain layer (cốt lõi)

Chứa toàn bộ logic hình học, không phụ thuộc Flutter UI.

```text
domain/
└─ shapes/
   ├─ shape.dart
   ├─ line.dart
   ├─ rectangle.dart
   ├─ circle.dart
   └─ ellipse.dart
```

Quy tắc:

- Không `setState`.
- Không file IO.
- Không widget.

## 3. Application layer (não hệ thống)

Chứa state + tool logic.

```text
application/
├─ canvas_controller.dart
├─ tool_controller.dart
└─ canvas_state.dart
```

### CanvasState

```dart
class CanvasState {
  final List<Shape> shapes;
  final Shape? previewShape;
}
```

### CanvasController

Xử lý toàn bộ flow vẽ:

```text
onPanStart  → lưu startPoint
onPanUpdate → tạo previewShape
onPanEnd    → commit vào shapes
```

Quy tắc:

- Giữ state.
- Không render trực tiếp.
- Không UI code.

## 4. Presentation layer (UI)

```text
presentation/
├─ canvas_widget.dart
├─ toolbar.dart
└─ canvas_painter.dart
```

### CanvasWidget

- Nhận gesture.
- Forward cho controller.

### CustomPainter

```dart
paint(Canvas canvas) {
  for (final shape in state.shapes) {
    shape.draw(canvas, paint);
  }

  state.previewShape?.draw(canvas, paint);
}
```

Quy tắc:

- Chỉ render.
- Không logic.

## 5. Infrastructure layer

```text
infrastructure/
├─ binary_storage.dart
└─ image_export.dart
```

Chức năng:

- Lưu / load file nhị phân shape.
- Export PNG / JPEG.

Không đụng state UI.

## 6. Luồng dữ liệu

```text
Gesture input
↓
CanvasController
↓
CanvasState update
↓
UI rebuild
↓
CustomPainter render
```

Một chiều. Không reverse dependency.

## 7. State management

Chọn một:

- `ChangeNotifier`: đơn giản, đủ dùng.
- `Riverpod`: dùng `StateNotifier` nếu muốn sạch hơn.

Không trộn.

## 8. Nguyên tắc quan trọng

1. `CanvasState` là nguồn sự thật duy nhất.
2. Shape tự vẽ, không dùng switch-case renderer trung tâm.
3. Controller xử lý toàn bộ lifecycle: preview → commit.
4. UI chỉ hiển thị + forward input.

## 9. Cái cần tránh

- Logic vẽ nằm trong widget.
- Painter chứa business logic.
- File IO trộn controller.
- Raster bitmap layer (không dùng nữa).
- Over-engineer Clean Architecture.
