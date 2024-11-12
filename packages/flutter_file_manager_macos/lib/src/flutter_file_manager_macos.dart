import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';

/// An implementation of [FileManagerPlatform] that uses MacOS method channels.
class FlutterFileManagerMacos extends FileManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_file_manager_macos');

  @override
  Future<String> writeFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    try {
      /// [String] & [Uint8List] are supported by Swift method channel.
      /// https://docs.flutter.dev/development/platform-integration/platform-channels?tab=type-mappings-swift-tab
      final path = await methodChannel.invokeMethod<String>(
        'writeFile',
        <String, dynamic>{
          'name': fileName,
          'bytes': bytes,
        },
      );
      return path!;
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

  @override
  Future<String> writeFileAsString({
    required String fileName,
    required String data,
  }) =>
      writeFile(
        fileName: fileName,
        bytes: Uint8List.fromList(utf8.encode(data)),
      );
}
