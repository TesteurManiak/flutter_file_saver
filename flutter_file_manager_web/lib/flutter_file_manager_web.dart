
import 'flutter_file_manager_web_platform_interface.dart';

class FlutterFileManagerWeb {
  Future<String?> getPlatformVersion() {
    return FlutterFileManagerWebPlatform.instance.getPlatformVersion();
  }
}
