import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/gen/method_channel_messages.dart',
    swiftOut: 'ios/Classes/MethodChannelMessages.g.swift',
    dartPackageName: 'flutter_file_manager_ios',
  ),
)
@HostApi()
abstract class IOSMessageApi {
  String writeFile({
    required String fileName,
    required Uint8List bytes,
  });
}
