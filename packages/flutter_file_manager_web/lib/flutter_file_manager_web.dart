import 'dart:convert';
import 'dart:js_interop' as js;

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

    final downloaded = await _downloadFile(
      bytes: bytes,
      name: name,
      type: mimeType,
    );

    return downloaded ? 'Downloads/$fileName' : '';
  }

  @override
  Future<String> writeFileAsString({
    required String fileName,
    required String data,
  }) async {
    return writeFile(
      fileName: fileName,
      bytes: Uint8List.fromList(utf8.encode(data)),
    );
  }

  Future<bool> _downloadFile({
    required Uint8List bytes,
    required String name,
    required String type,
  }) async {
    try {
      final url = web.URL.createObjectURL(
        web.Blob(
          [bytes.toJS].toJS,
          web.BlobPropertyBag(type: type),
        ),
      );
      final htmlDocument = web.document;
      final anchor = htmlDocument.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.style.display = name;
      anchor.download = name;
      anchor.type = type;
      web.document.body?.children.add(anchor);
      anchor.click();
      web.document.body?.removeChild(anchor);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
