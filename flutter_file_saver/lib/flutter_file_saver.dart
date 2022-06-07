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

  /// Write [data] inside [fileName] and return the path to the file.
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
  }) =>
      _platform.writeFileAsString(
        fileName: fileName,
        data: data,
      );

  /// Write [bytes] inside [fileName] and return the path to the file.
  ///
  /// {@macro flutterFileSaver.macos.openFinder}
  Future<String> writeFileAsBytes({
    required String fileName,
    required Uint8List bytes,
  }) =>
      _platform.writeFile(
        fileName: fileName,
        bytes: bytes,
      );
}
