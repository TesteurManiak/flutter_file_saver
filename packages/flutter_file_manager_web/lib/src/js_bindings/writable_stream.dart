import 'dart:js_interop' as js;

/// Dart wrapper for the `WritableStream` interface.
///
/// Creates a new `WritableStream` object.
///
/// https://developer.mozilla.org/en-US/docs/Web/API/WritableStream
@js.JS('WritableStream')
extension type JSWritableStream(js.JSObject _) implements js.JSObject {
  @js.JS('locked')
  external js.JSBoolean get _lockedJS;

  /// Call the `WritableStream.locked` property.
  ///
  /// A boolean indicating whether the WritableStream is locked to a writer.
  ///
  /// https://developer.mozilla.org/en-US/docs/Web/API/WritableStream/locked
  bool get locked => _lockedJS.toDart;

  @js.JS('close')
  external js.JSPromise<js.JSAny?> _closeJS();

  /// Call the `WritableStream.close()` method.
  ///
  /// Closes the stream.
  ///
  /// https://developer.mozilla.org/en-US/docs/Web/API/WritableStream/close
  Future<void> close() => _closeJS().toDart;
}
