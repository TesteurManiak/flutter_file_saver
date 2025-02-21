import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/gen/method_channel_messages.dart',
    swiftOut: 'macos/Classes/MethodChannelMessages.g.swift',
    dartPackageName: 'flutter_file_manager_macos',
  ),
)
@HostApi()
abstract class MacOSMessageApi {
  @async
  String writeFile({
    required String fileName,
    required Uint8List bytes,
  });
}
