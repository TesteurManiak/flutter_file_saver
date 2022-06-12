import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';
import 'package:mime/mime.dart';

class FlutterFileManagerAndroid extends FileManagerPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_file_manager_android');

  @override
  Future<String> writeFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final mimeType = lookupMimeType(fileName);
    final path = await methodChannel.invokeMethod<String>(
      'writeFile',
      <String, dynamic>{
        'sourceFilePath': null, // TODO: support this param
        'name': fileName,
        'bytes': bytes,
        'types': mimeType != null ? <String>[mimeType] : null,
        'localOnly': false, // TODO: support this param
      },
    );
    return path ?? 'Unknown';
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
}
