library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';
import 'package:path_provider/path_provider.dart';

import 'src/gen/method_channel_messages.dart';

class FlutterFileManagerIos extends FileManagerPlatform {
  @visibleForTesting
  final api = IOSMessageApi();

  @override
  Future<String> writeFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    // To find the file in the document folder I had to also set
    // `UISupportsDocumentBrowser`, `UIFileSharingEnabled` and
    // `LSSupportsOpeningDocumentsInPlace` to `YES` in the
    // `ios/Runner/info.plist`.
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final appDocumentsPath = appDocumentsDirectory.path;
    final filePath = '$appDocumentsPath/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }
}
