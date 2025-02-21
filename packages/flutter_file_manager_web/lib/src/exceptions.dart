class FlutterFileManagerWebException implements Exception {
  const FlutterFileManagerWebException(this.message);

  final String message;

  @override
  String toString() => 'FlutterFileManagerWebException: $message';
}
