import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_file_manager_web_platform_interface.dart';

/// An implementation of [FlutterFileManagerWebPlatform] that uses method channels.
class MethodChannelFlutterFileManagerWeb extends FlutterFileManagerWebPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_file_manager_web');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
