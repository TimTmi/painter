import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:paint/infrastructure/image_export_writer.dart';

class ImageExport {
  final ImageExportWriter _writer = createImageExportWriter();

  Future<String> exportPng({
    required GlobalKey repaintBoundaryKey,
    double pixelRatio = 3,
  }) async {
    final boundary =
        repaintBoundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;

    if (boundary == null) {
      throw StateError('Canvas boundary is not available for export.');
    }

    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw StateError('Failed to encode canvas to PNG bytes.');
    }

    final fileName = _buildFileName();
    return _writer.writePng(byteData.buffer.asUint8List(), fileName);
  }

  String _buildFileName() {
    final now = DateTime.now();
    final datePart =
        '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final timePart =
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

    return 'painter_$datePart$timePart.png';
  }
}
