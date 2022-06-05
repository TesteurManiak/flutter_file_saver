import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_file_manager_web_method_channel.dart';

abstract class FlutterFileManagerWebPlatform extends PlatformInterface {
  /// Constructs a FlutterFileManagerWebPlatform.
  FlutterFileManagerWebPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFileManagerWebPlatform _instance = MethodChannelFlutterFileManagerWeb();

  /// The default instance of [FlutterFileManagerWebPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFileManagerWeb].
  static FlutterFileManagerWebPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFileManagerWebPlatform] when
  /// they register themselves.
  static set instance(FlutterFileManagerWebPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
