import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';

class FlutterFileManagerIos extends FileManagerPlatform {
  @override
  Future<String> writeFile({
    required String fileName,
    required Uint8List bytes,
    MimeType? type,
  }) async {
    return '';
  }

  @override
  Future<String> writeFileAsString({
    required String fileName,
    required String data,
    MimeType? type,
  }) =>
      writeFile(
        fileName: fileName,
        bytes: Uint8List.fromList(utf8.encode(data)),
        type: type,
      );
}
