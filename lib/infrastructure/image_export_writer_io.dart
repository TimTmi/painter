import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:paint/infrastructure/image_export_writer.dart';

class _IoImageExportWriter implements ImageExportWriter {
  @override
  Future<String> writePng(Uint8List bytes, String fileName) async {
    final path = await FilePicker.saveFile(
      dialogTitle: 'Export PNG',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['png'],
      bytes: bytes,
    );

    if (path == null) {
      throw StateError('User cancelled export.');
    }

    return path;
  }
}

ImageExportWriter createWriter() => _IoImageExportWriter();
