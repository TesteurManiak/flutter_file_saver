import 'package:flutter/services.dart';

abstract final class FileSaverErrorCode {
  const FileSaverErrorCode._();

  static const cancelled = 'CANCELLED';
}

class FileSaverException extends PlatformException {
  FileSaverException({
    required super.code,
    super.message,
    super.stacktrace,
    super.details,
  });
}

class FileSaverCancelledException extends FileSaverException {
  FileSaverCancelledException() : super(code: FileSaverErrorCode.cancelled);

  @override
  String toString() => 'Operation was cancelled';
}
