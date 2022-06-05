import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FlutterFileManagerAndroid extends FileManagerPlatform {
  @override
  Future<String> writeFile({
    required String fileName,
    required Uint8List bytes,
    MimeType? type,
  }) async {
    if (await _requestPermission(Permission.storage)) {
      final appDocumentsDirectory = await getExternalStorageDirectory();
      final appDocumentsPath = appDocumentsDirectory!.path;
      final filePath = '$appDocumentsPath/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath;
    } else {
      throw Exception('Permission denied');
    }
  }

  @override
  Future<String> writeFileAsString({
    required String fileName,
    required String data,
    MimeType? type,
  }) {
    return writeFile(
      fileName: fileName,
      bytes: Uint8List.fromList(utf8.encode(data)),
      type: type,
    );
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      return result.isGranted;
    }
  }
}
