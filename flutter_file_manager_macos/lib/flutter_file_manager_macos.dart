import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_manager_platform_interface/flutter_file_manager_platform_interface.dart';

/// An implementation of [FileManagerPlatform] that uses MacOS method channels.
class FlutterFileManagerMacos extends FileManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_file_manager_macos');

  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
