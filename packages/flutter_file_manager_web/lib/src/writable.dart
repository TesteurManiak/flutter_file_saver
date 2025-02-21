import 'dart:js_interop' as js;
import 'dart:js_interop_unsafe';

Future<js.JSObject> createWritable(js.JSObject window) async {
  final writable =
      await window.callMethod<js.JSPromise>('createWritable'.toJS).toDart;
  if (writable == null || !writable.isA<js.JSObject>()) {
    throw Exception('Writable is null.');
  }
  return writable as js.JSObject;
}
