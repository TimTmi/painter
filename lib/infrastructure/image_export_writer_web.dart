// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:typed_data';

import 'package:paint/infrastructure/image_export_writer.dart';

class _WebImageExportWriter implements ImageExportWriter {
  @override
  Future<String> writePng(Uint8List bytes, String fileName) async {
    final blob = html.Blob([bytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = fileName
      ..style.display = 'none';

    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);

    return 'Downloaded $fileName';
  }
}

ImageExportWriter createWriter() => _WebImageExportWriter();
