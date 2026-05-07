import 'dart:typed_data';

import 'package:paint/infrastructure/image_export_writer.dart';

class _UnsupportedImageExportWriter implements ImageExportWriter {
  @override
  Future<String> writePng(Uint8List bytes, String fileName) {
    throw UnsupportedError('Image export is not supported on this platform.');
  }
}

ImageExportWriter createWriter() => _UnsupportedImageExportWriter();
