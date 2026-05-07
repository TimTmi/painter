import 'dart:typed_data';

import 'package:paint/infrastructure/image_export_writer_stub.dart'
    if (dart.library.html) 'package:paint/infrastructure/image_export_writer_web.dart'
    if (dart.library.io) 'package:paint/infrastructure/image_export_writer_io.dart';

abstract class ImageExportWriter {
  Future<String> writePng(Uint8List bytes, String fileName);
}

ImageExportWriter createImageExportWriter() => createWriter();
