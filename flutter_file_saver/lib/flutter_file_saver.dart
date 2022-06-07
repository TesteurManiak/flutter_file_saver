import 'dart:io' as io;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_file_manager_android/flutter_file_manager_android.dart';
import 'package:flutter_file_manager_ios/flutter_file_manager_ios.dart';
import 'package:flutter_file_manager_macos/flutter_file_manager_macos.dart';
import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';

class FlutterFileSaver {
  static bool _manualRegistrationNeeded = true;

  FlutterFileSaver._();

  factory FlutterFileSaver() {
    _singleton ??= FlutterFileSaver._();
    return _singleton!;
  }

  static FlutterFileSaver? _singleton;

  static FileManagerPlatform get _platform {
    if (_manualRegistrationNeeded) {
      if (!kIsWeb &&
          FileManagerPlatform.instance is FileManagerPlatformException) {
        if (io.Platform.isAndroid) {
          FileManagerPlatform.instance = FlutterFileManagerAndroid();
        } else if (io.Platform.isIOS) {
          FileManagerPlatform.instance = FlutterFileManagerIos();
        } else if (io.Platform.isMacOS) {
          FileManagerPlatform.instance = FlutterFileManagerMacos();
        }
      }
      _manualRegistrationNeeded = false;
    }
    return FileManagerPlatform.instance;
  }

  /// Write [data] inside [fileName] and return the path to the file. The
  /// parameter is only used on web.
  ///
  /// {@template flutterFileSaver.web.mimeType}
  /// ### Web only
  ///
  /// The parameter [type] is only used to define the encoding type of the
  /// created file.
  /// If it is `null`, type will be infered from the [fileName] (e.g:
  /// `test.json` will infer the [MimeType.json]).
  /// {@endtemplate}
  ///
  /// {@template flutterFileSaver.macos.openFinder}
  /// ### MacOS only
  ///
  /// This method will also open the finder pointing to the folder
  /// containing the file.
  /// {@endtemplate}
  Future<String> writeFileAsString({
    required String fileName,
    required String data,
    MimeType? type,
  }) =>
      _platform.writeFileAsString(
        fileName: fileName,
        data: data,
        type: type,
      );

  /// Write [bytes] inside [fileName] and return the path to the file. The
  /// parameter is only used on web.
  ///
  /// {@macro flutterFileSaver.web.mimeType}
  ///
  /// {@macro flutterFileSaver.macos.openFinder}
  Future<String> writeFileAsBytes({
    required String fileName,
    required Uint8List bytes,
    MimeType? type,
  }) =>
      _platform.writeFile(
        fileName: fileName,
        bytes: bytes,
        type: type,
      );
}
