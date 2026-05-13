# Painter - Ứng dụng vẽ cơ bản đa nền tảng

## Thông tin nhóm

| STT | MSSV | Họ và tên |
| --- | --- | --- |
| 1 | 23127221 | Nguyễn Tiến Luật |
| 2 | 23127228 | Phạm Văn Minh |
| 3 | 23127281 | Đặng Nghi Văn |
| 4 | 23127395 | Trần Anh Khoa |

## Giới thiệu đề tài

Painter là ứng dụng vẽ cơ bản được xây dựng bằng Flutter, hỗ trợ chạy trên Windows và thiết bị Mobile. Ứng dụng cho phép người dùng vẽ các đối tượng hình học cơ bản, tùy chỉnh màu sắc, độ dày đường viền, lưu bản vẽ bằng định dạng nhị phân tự định nghĩa và nạp lại để tiếp tục chỉnh sửa.

## Công nghệ sử dụng

- Flutter / Dart
- Material Design
- File Picker để chọn nơi lưu và mở tệp bản vẽ
- CustomPainter để hiển thị các đối tượng vẽ trên canvas

## Các chức năng đã thực hiện

- Vẽ các đối tượng cơ bản:
  - Điểm
  - Đường thẳng
  - Hình chữ nhật
  - Hình vuông
  - Hình tròn
  - Hình ellipse
- Hỗ trợ tô màu cho các hình có vùng bên trong.
- Hỗ trợ chọn màu đường viền.
- Hỗ trợ chọn độ dày đường viền từ 1 đến 20.
- Hỗ trợ công cụ Fill để đổi màu tô của đối tượng.
- Hỗ trợ công cụ Erase để xóa đối tượng trên canvas.
- Hỗ trợ lưu bản vẽ dưới dạng tệp nhị phân tự định nghĩa với phần mở rộng `.pnt`.
- Hỗ trợ nạp lại tệp `.pnt` đã lưu để tiếp tục vẽ và chỉnh sửa.
- Hỗ trợ xuất canvas ra ảnh PNG.
- Hiển thị tọa độ điểm bắt đầu, điểm hiện tại và trạng thái vẽ khi thao tác trên canvas.

## Định dạng tệp nhị phân tự định nghĩa

Ứng dụng sử dụng định dạng `.pnt` để lưu danh sách các đối tượng trên canvas. Mỗi tệp lưu bao gồm:

- Magic header: `PNTR`
- Phiên bản định dạng tệp
- Số lượng đối tượng
- Thông tin từng đối tượng: loại hình, độ dày nét vẽ, màu đường viền, màu tô, điểm bắt đầu và điểm kết thúc

## Hướng dẫn chạy ứng dụng

Tại thư mục gốc của dự án, chạy các lệnh:

```bash
flutter pub get
flutter run
```

Chạy riêng trên Windows:

```bash
flutter run -d windows
```

Khi chạy trên thiết bị Mobile hoặc emulator, chọn thiết bị từ danh sách của Flutter:

```bash
flutter devices
flutter run -d <device_id>
```

## Hướng dẫn sử dụng

1. Chọn công cụ vẽ trên thanh toolbar: Point, Line, Rect, Square, Circle hoặc Ellipse.
2. Chọn màu đường viền ở mục Stroke.
3. Chọn màu tô ở mục Fill.
4. Điều chỉnh độ dày đường viền bằng thanh Width.
5. Kéo thả trên canvas để vẽ hình, hoặc chạm/click để tạo điểm.
6. Chọn Fill để tô lại màu cho đối tượng.
7. Chọn Erase để xóa đối tượng.
8. Bấm Save để lưu bản vẽ thành tệp `.pnt`.
9. Bấm Load để nạp lại tệp `.pnt`.
10. Bấm Export PNG để xuất bản vẽ ra ảnh PNG.

## Video demo

- Link video demo các chức năng: [Xem video demo](https://drive.google.com/file/d/1uhm9wS7eZk79s2Y1VIikEjtv8Q3mVEOf/view?usp=sharing)

## Kiểm thử

Dự án có các bài test cho những phần chính:

- Tạo đối tượng vẽ
- Kiểm tra phát hiện đối tượng khi thao tác trên canvas
- Lưu và đọc lại tệp nhị phân
- Kiểm tra các module xử lý vẽ

Chạy test bằng lệnh:

```bash
flutter test
```
