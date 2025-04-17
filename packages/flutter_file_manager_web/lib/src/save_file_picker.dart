import 'dart:js_interop' as js;

import '../flutter_file_manager_web.dart';
import 'js_bindings/file_system_handle.dart';

@js.JS('window.showSaveFilePicker')
external js.JSPromise<JSFileSystemFileHandle?> _showSaveFilePicker(
  JSSaveFilePickerOptions? options,
);

@js.JS()
extension type JSSaveFilePickerOptions._(js.JSObject _) implements js.JSObject {
  external bool? get excludeAcceptAllOption;
  external set excludeAcceptAllOption(bool? value);

  external String? get id;
  external set id(String? value);

  external String? get suggestedName;
  external set suggestedName(String? value);

  external js.JSArray<JSFilePickerType>? get types;
  external set types(js.JSArray<JSFilePickerType>? value);
}

@js.JS()
extension type JSFilePickerType._(js.JSObject _) implements js.JSObject {
  external String? get description;
  external set description(String? value);

  external js.JSAny? get accept;
  external set accept(js.JSAny? value);
}

Future<JSFileSystemFileHandle> showSaveFilePicker([
  SaveFilePickerOptions? options,
]) async {
  final fileHandle = await _showSaveFilePicker(options?.toJS).toDart;

  if (fileHandle == null) {
    throw FlutterFileManagerWebException('File handle is null.');
  }

  return fileHandle;
}

class SaveFilePickerOptions {
  const SaveFilePickerOptions({
    this.excludeAcceptAllOption = false,
    this.id,
    this.suggestedName,
    this.types,
  });

  final bool excludeAcceptAllOption;
  final String? id;
  final String? suggestedName;
  final List<FilePickerType>? types;

  JSSaveFilePickerOptions get toJS {
    return JSSaveFilePickerOptions._(js.JSObject())
      ..excludeAcceptAllOption = excludeAcceptAllOption
      ..id = id
      ..suggestedName = suggestedName
      ..types = types?.map((e) => e.toJS).toList().toJS;
  }
}

class FilePickerType {
  const FilePickerType({
    required this.accept,
    this.description = '',
  }) : assert(accept.length > 0);

  final String description;
  final Map<String, List<String>> accept;

  JSFilePickerType get toJS {
    return JSFilePickerType._(js.JSObject())
      ..description = description
      ..accept = accept.jsify();
  }
}
