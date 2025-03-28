import 'dart:js_interop' as js;

import 'file_system_writable_file_stream.dart';

/// Dart wrapper for the `FileSystemFileHandle` interface.
///
/// https://developer.mozilla.org/en-US/docs/Web/API/FileSystemFileHandle
@js.JS()
extension type JSFileSystemFileHandle._(js.JSObject _) implements js.JSObject {
  @js.JS('createWritable')
  external js.JSPromise<JSFileSystemWritableFileStream?> _createWritableJS();

  /// Call the `FileSystemFileHandle.createWritable()` method.
  ///
  /// Resolves to a newly created [JSFileSystemWritableFileStream] object that
  /// can be used to write to a file.
  ///
  /// https://developer.mozilla.org/en-US/docs/Web/API/FileSystemFileHandle/createWritable
  Future<JSFileSystemWritableFileStream?> createWritable() =>
      _createWritableJS().toDart;
}
