import 'dart:js_interop' as js;
import 'dart:js_interop_unsafe';

import 'exceptions.dart';

Future<js.JSObject> showSaveFilePicker(
  js.JSObject window, {
  SaveFilePickerOptions? options,
}) async {
  final fileHandle = await window
      .callMethod<js.JSPromise>(
        'showSaveFilePicker'.toJS,
        options?.toJson().jsify(),
      )
      .toDart;

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

  /// A boolean value that defaults to false. By default, the picker should
  /// include an option to not apply any file type filters (instigated with the
  /// type option below). Setting this option to true means that option is not
  /// available.
  final bool excludeAcceptAllOption;

  /// By specifying an ID, the browser can remember different directories for
  /// different IDs. If the same ID is used for another picker, the picker opens
  /// in the same directory.
  final String? id;

  /// The suggested file name.
  final String? suggestedName;

  /// An Array of allowed file types to save.
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

  /// An optional description of the category of files types allowed. Default to
  /// be an empty string.
  final String description;

  /// A map with the keys set to the MIME type and the values an Array of file
  /// extensions.
  final Map<String, List<String>> accept;

  Map<String, Object> toJson() {
    return {
      'description': description,
      'accept': accept,
    };
  }
}
