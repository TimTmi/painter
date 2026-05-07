import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:paint/domain/shapes/shape.dart';
import 'package:paint/infrastructure/binary_storage.dart';

abstract interface class BinaryFileService {
  Future<bool> saveShapes(Iterable<Shape> shapes);

  Future<List<Shape>?> loadShapes();
}

class FilePickerBinaryFileService implements BinaryFileService {
  const FilePickerBinaryFileService();

  @override
  Future<bool> saveShapes(Iterable<Shape> shapes) async {
    final bytes = BinaryStorage.encodeShapes(shapes);
    final path = await FilePicker.saveFile(
      dialogTitle: 'Save painter file',
      fileName: BinaryStorage.defaultFileName,
      type: FileType.custom,
      allowedExtensions: const [BinaryStorage.fileExtension],
      bytes: bytes,
      lockParentWindow: true,
    );

    return kIsWeb || path != null;
  }

  @override
  Future<List<Shape>?> loadShapes() async {
    final result = await FilePicker.pickFiles(
      dialogTitle: 'Open painter file',
      type: FileType.custom,
      allowedExtensions: const [BinaryStorage.fileExtension],
      withData: true,
      lockParentWindow: true,
    );

    final files = result?.files;
    if (files == null || files.isEmpty) {
      return null;
    }

    final bytes = files.single.bytes;
    if (bytes == null) {
      return null;
    }

    return BinaryStorage.decodeShapes(bytes);
  }
}
