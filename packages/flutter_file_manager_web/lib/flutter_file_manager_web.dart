import 'dart:js_interop' as js;
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart';
import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mime/mime.dart';
import 'package:web/web.dart' as web;

class FlutterFileManagerWeb extends FileManagerPlatform {
  static void registerWith(Registrar registrar) {
    FileManagerPlatform.instance = FlutterFileManagerWeb();
  }

  @override
  Future<String> writeFile({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final splittedName = fileName.split('.');
    final name = splittedName[0];
    final mimeType = lookupMimeType(fileName) ?? 'application/octet-stream';

    if (_isFileSystemAccessAPIAvailable()) {
      await _showSaveFilePicker(bytes: bytes, name: name, mimeType: mimeType);
    }

    await _downloadFile(bytes: bytes, name: name, mimeType: mimeType);

    return '';
  }

  /// Downloads the file using the browser's download API.
  ///
  /// Works on all browsers.
  Future<void> _downloadFile({
    required Uint8List bytes,
    required String name,
    required String mimeType,
  }) async {
    final url = web.URL.createObjectURL(
      web.Blob(
        [bytes.toJS].toJS,
        web.BlobPropertyBag(type: mimeType),
      ),
    );
    final htmlDocument = web.document;
    final anchor = htmlDocument.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.style.display = name;
    anchor.download = name;
    anchor.type = mimeType;
    web.document.body?.children.add(anchor);
    anchor.click();
    web.document.body?.removeChild(anchor);
  }

  /// Relies on the browser's File System Access API to save the file using the
  /// JavaScript `showSaveFilePicker` method.
  ///
  /// Works only on modern browsers.
  Future<void> _showSaveFilePicker({
    required Uint8List bytes,
    required String name,
    required String mimeType,
  }) async {
    final window = js.globalContext;

    final fileExtension = name.split('.').lastOrNull;
    if (fileExtension == null) {
      throw FlutterFileManagerWebException('Missing file extension.');
    }

    final options = {
      'suggestedName': name,
      'types': [
        {
          'description': 'Selected File',
          'accept': {
            mimeType: ['.$fileExtension'],
          },
        },
      ],
    }.toJSBox;

    try {
      final fileHandle = await window.callMethodVarArgs<js.JSPromise>(
        'showSaveFilePicker'.toJS,
        [options],
      ).toDart;

      print('RESULT: $fileHandle');
    } on web.DOMException catch (e) {
      // Convert an abort error to a custom exception.
      if (e case web.DOMException(code: 20, name: 'AbortError')) {
        throw FileSaverCancelledException();
      }
      rethrow;
    }
  }

  /// Check the availability of the File System Access API by checking if the
  /// `showSaveFilePicker` method is available in the global context.
  bool _isFileSystemAccessAPIAvailable() {
    final window = js.globalContext;
    return window.hasProperty('showSaveFilePicker'.toJS).toDart;
  }
}

class FlutterFileManagerWebException implements Exception {
  const FlutterFileManagerWebException(this.message);

  final String message;

  @override
  String toString() => 'FlutterFileManagerWebException: $message';
}
