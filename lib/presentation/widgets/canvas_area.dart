import 'package:flutter/material.dart';

class CanvasDragState {
  const CanvasDragState({
    required this.startPoint,
    required this.currentPoint,
    required this.isDragging,
  });

  final Offset startPoint;
  final Offset currentPoint;
  final bool isDragging;
}

class CanvasArea extends StatefulWidget {
  const CanvasArea({super.key, this.onDragChanged});

  final ValueChanged<CanvasDragState>? onDragChanged;

  @override
  State<CanvasArea> createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasArea> {
  Offset? _startPoint;
  Offset? _currentPoint;

  void _emitDragState({required bool isDragging}) {
    final startPoint = _startPoint;
    final currentPoint = _currentPoint;

    if (startPoint == null || currentPoint == null) {
      return;
    }

    widget.onDragChanged?.call(
      CanvasDragState(
        startPoint: startPoint,
        currentPoint: currentPoint,
        isDragging: isDragging,
      ),
    );
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() {
      _startPoint = details.localPosition;
      _currentPoint = details.localPosition;
    });
    _emitDragState(isDragging: true);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentPoint = details.localPosition;
    });
    _emitDragState(isDragging: true);
  }

  void _handlePanEnd(DragEndDetails details) {
    _emitDragState(isDragging: false);
  }

  void _handlePanCancel() {
    _emitDragState(isDragging: false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onPanCancel: _handlePanCancel,
      child: CustomPaint(
        painter: const CanvasBackgroundPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class CanvasBackgroundPainter extends CustomPainter {
  const CanvasBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final borderPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(Offset.zero & size, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CanvasBackgroundPainter oldDelegate) => false;
}
