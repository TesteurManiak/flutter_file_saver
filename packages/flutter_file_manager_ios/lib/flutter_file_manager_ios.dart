library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';

import 'src/gen/method_channel_messages.dart';

class FlutterFileManagerIos extends FileManagerPlatform {
  @visibleForTesting
  final api = IOSMessageApi();

  @override
  Future<String> writeFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    try {
      final path = await api.writeFile(fileName: fileName, bytes: bytes);
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
