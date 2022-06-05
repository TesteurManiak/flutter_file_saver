import 'dart:typed_data';

import 'mime_type.dart';

abstract class FileManagerPlatform {
  static FileManagerPlatform instance = FileManagerPlatformException();

  /// Write [data] inside [fileName] and return the path to the file.
  ///
  /// - `fileName`: The name of the file (e.g: `my_file.json`).
  /// - `data`: The data to write inside the file.
  /// - `type`: The type of the file, used for the web implementation. If not
  ///  provided, the type will be guessed by parsing the `fileName` extension.
  Future<String> writeFileAsString({
    required String fileName,
    required String data,
    MimeType? type,
  }) {
    throw UnimplementedError('writeFile() has not been implemented.');
  }

  /// Write [bytes] inside [fileName] and return the path to the file.
  ///
  /// - `fileName`: The name of the file (e.g: `my_file.json`).
  /// - `bytes`: The data to write inside the file.
  /// - `type`: The type of the file, used for the web implementation. If not
  ///  provided, the type will be guessed by parsing the `fileName` extension.
  Future<String> writeFile({
    required String fileName,
    required Uint8List bytes,
    MimeType? type,
  }) {
    throw UnimplementedError('writeFile() has not been implemented.');
  }
}

class FileManagerPlatformException extends FileManagerPlatform {}
