import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';

class FlutterFileManagerAndroid extends FileManagerPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_file_manager_android');

  @override
  Future<String> writeFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    if (await _requestPermission(Permission.storage)) {
      final path = await methodChannel.invokeMethod<String>(
        'writeFile',
        <String, dynamic>{
          'name': fileName,
          'bytes': bytes,
          'type': lookupMimeType(fileName)
        },
      );
      return path ?? 'Unknown';
    } else {
      throw Exception('Permission denied');
    }
  }

  @override
  Future<String> writeFileAsString({
    required String fileName,
    required String data,
  }) {
    return writeFile(
      fileName: fileName,
      bytes: Uint8List.fromList(utf8.encode(data)),
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
