import 'dart:js_interop' as js;

import '../flutter_file_manager_web.dart';

@js.JS('window.showSaveFilePicker')
external js.JSPromise<js.JSAny?> _showSaveFilePicker(js.JSAny? options);

Future<js.JSObject> showSaveFilePicker([
  SaveFilePickerOptions? options,
]) async {
  final fileHandle =
      await _showSaveFilePicker(options?.toJson().jsify()).toDart;

  if (fileHandle == null || !fileHandle.isA<js.JSObject>()) {
    throw FlutterFileManagerWebException('File handle is null.');
  }

  return fileHandle as js.JSObject;
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

  Map<String, Object> toJson() {
    return {
      'excludeAcceptAllOption': excludeAcceptAllOption,
      if (id case final id?) 'id': id,
      if (suggestedName case final name?) 'suggestedName': name,
      if (types case final types? when types.isNotEmpty)
        'types': types.map((e) => e.toJson()).toList(),
    };
  }
}

class FilePickerType {
  const FilePickerType({
    required this.accept,
    this.description = '',
  }) : assert(accept.length > 0);

  final String description;
  final Map<String, List<String>> accept;

  Map<String, Object> toJson() {
    return {
      'description': description,
      'accept': accept,
    };
  }
}
