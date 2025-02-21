import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/gen/method_channel_messages.dart',
    kotlinOut:
        'android/src/main/kotlin/com/maniak/flutter_file_manager_android/MethodChannelMessages.g.kt',
    dartPackageName: 'flutter_file_manager_android',
  ),
)
@HostApi()
abstract class AndroidMessageApi {
  @async
  String writeFile({
    required String fileName,
    required String? mimeType,
    required Uint8List bytes,
  });
}
