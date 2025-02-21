import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';
import 'package:mime/mime.dart';

import 'src/gen/method_channel_messages.dart';

class FlutterFileManagerAndroid extends FileManagerPlatform {
  @visibleForTesting
  final api = AndroidMessageApi();

  @override
  Future<String> writeFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final mimeType = lookupMimeType(fileName);
    try {
      final path = await api.writeFile(
        fileName: fileName,
        mimeType: mimeType,
        bytes: bytes,
      );
      return path;
    } on PlatformException catch (e, s) {
      switch (e.code) {
        case FileSaverErrorCode.cancelled:
          throw FileSaverCancelledException();
        default:
          throw FileSaverException(
            code: e.code,
            message: e.message,
            details: e.details,
            stacktrace: s.toString(),
          );
      }
    }
  }
}
