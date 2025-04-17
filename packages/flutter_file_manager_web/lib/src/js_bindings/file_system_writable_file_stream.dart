import 'dart:js_interop' as js;
import 'dart:typed_data';

import 'writable_stream.dart';

/// Dart wrapper for the `FileSystemWritableFileStream` interface.
///
/// https://developer.mozilla.org/en-US/docs/Web/API/FileSystemWritableFileStream
@js.JS()
extension type JSFileSystemWritableFileStream._(JSWritableStream _)
    implements JSWritableStream {
  @js.JS('write')
  external js.JSPromise<js.JSAny?> _writeJS(js.JSUint8Array bytes);

  /// Call the `FileSystemWritableFileStream.write()` method.
  ///
  /// https://developer.mozilla.org/en-US/docs/Web/API/FileSystemWritableFileStream/write
  Future<void> write(Uint8List bytes) => _writeJS(bytes.toJS).toDart;
}
