import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter_file_manager_android/flutter_file_manager_android.dart';
import 'package:flutter_file_manager_ios/flutter_file_manager_ios.dart';
import 'package:flutter_file_manager_macos/flutter_file_manager_macos.dart';
import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';

export 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart'
    show FileManagerPlatform, FileSaverException, FileSaverCancelledException;

/// Allows to write files to the device's file system.
class FlutterFileSaver {
  static bool _manualRegistrationNeeded = true;

  FlutterFileSaver._();

  /// Constructs a singleton instance of [FlutterFileSaver].
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

  ///  Allows you to mock the [FileManagerPlatform] instance for testing.
  @visibleForTesting
  void setFileSaverInstance(FileManagerPlatform platform) {
    FileManagerPlatform.instance = platform;
  }

  /// Write [data] inside [fileName] and return the path to the file (except for
  /// web where it will returns an empty string if successful).
  Future<String> writeFileAsString({
    required String fileName,
    required String data,
  }) =>
      _platform.writeFileAsString(
        fileName: fileName,
        data: data,
      );

  /// Write [bytes] inside [fileName] and return the path to the file (except
  /// for web where it will returns an empty string if successful).
  Future<String> writeFileAsBytes({
    required String fileName,
    required Uint8List bytes,
  }) =>
      _platform.writeFile(
        fileName: fileName,
        bytes: bytes,
      );
}
