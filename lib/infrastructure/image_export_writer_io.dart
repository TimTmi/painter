import 'dart:io';
import 'dart:typed_data';

import 'package:paint/infrastructure/image_export_writer.dart';

class _IoImageExportWriter implements ImageExportWriter {
  @override
  Future<String> writePng(Uint8List bytes, String fileName) async {
    final directory = await _resolveOutputDirectory();
    final filePath = '${directory.path}${Platform.pathSeparator}$fileName';
    final outputFile = File(filePath);

    await outputFile.writeAsBytes(bytes, flush: true);

    return outputFile.path;
  }

  Future<Directory> _resolveOutputDirectory() async {
    try {
      final cwd = Directory.current;
      if (await cwd.exists()) {
        return cwd;
      }
    } catch (_) {
      // Ignore and fall back below.
    }

    return Directory.systemTemp;
  }
}

ImageExportWriter createWriter() => _IoImageExportWriter();
