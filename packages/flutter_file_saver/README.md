# flutter_file_saver

[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg)](https://github.com/invertase/melos)
[![Pub Version](https://img.shields.io/pub/v/flutter_file_saver)](https://pub.dev/packages/flutter_file_saver)

Interface to provide a way to save files on the device in Flutter.

## Platform Support

| | Android | iOS | Web | Windows | Linux | MacOS |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| `writeFileAsBytes` | ✅ | ✅ | ✅  | ❌️ | ❌️ | ✅ |
| `writeFileAsString` | ✅ | ✅ | ✅  | ❌️ | ❌️ | ✅ |

Under the hood, each implementation tries to use the native dialog to save the file:
- Android: [`ACTION_CREATE_DOCUMENT` intent](https://developer.android.com/reference/android/content/Intent#ACTION_CREATE_DOCUMENT) is used
- iOS: [`UIDocumentPickerViewController`](https://developer.apple.com/documentation/uikit/uidocumentpickerviewcontroller) is used
- MacOS: [`NSSavePanel`](https://developer.apple.com/documentation/appkit/nssavepanel) is used
- Web: It will try to use the [`showSaveFilePicker` API](https://developer.mozilla.org/en-US/docs/Web/API/Window/showSaveFilePicker) if available, otherwise it will try to use the `download` attribute on an anchor tag

## Getting Started

### Import the package

```yaml
dependencies:
    flutter_file_saver: any
```

### Platform Setup

<details>
<summary>Android Setup</summary>

```gradle
android {
    defaultConfig {
        minSdkVersion 19
    }
}
```

[Check example](https://github.com/TesteurManiak/flutter_file_saver/blob/main/packages/flutter_file_saver/example/android/app/build.gradle#L45-L54)
</details>

<details>
<summary>iOS Setup (Needs iOS 16+)</summary>

Add the following permissions to your `ios/Runner/Info.plist`:

```xml
<key>UISupportsDocumentBrowser</key>
<true/>
<key>UIFileSharingEnabled</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

[Check example](https://github.com/TesteurManiak/flutter_file_saver/blob/main/packages/flutter_file_saver/example/ios/Runner/Info.plist#L48-L53)
</details>

<details>
<summary>MacOS Setup</summary>

Add the following permissions to your `macos/Runner/DebugProfile.entitlements`:

```xml
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

[Check example](https://github.com/TesteurManiak/flutter_file_saver/blob/main/packages/flutter_file_saver/example/macos/Runner/DebugProfile.entitlements#L11-L12)
</details>

## Methods

### `writeFileAsBytes`

Write a file on the device from a `Uint8List`.

```dart
FlutterFileSaver().writeFileAsBytes(
    fileName: 'file.txt',
    bytes: fileBytes,
);
```

### `writeFileAsString`

Write a file on the device from a `String`. This will most of the time convert your data and perform a call to `writeFileAsBytes`.

```dart
FlutterFileSaver().writeFileAsString(
    fileName: 'file.txt',
    string: 'Hello World!',
);
```

## Known Issues

### Web - `SecurityError: Failed to execute 'showSaveFilePicker' on 'Window'`

This is a known issue with the `showSaveFilePicker` JavaScript API on the Web. It is caused when `writeFileAsBytes`/`writeFileAsString` is not immediately called after a user interaction (like a button click). This is a security feature of the browser to prevent malicious sites from opening file pickers without user consent.

```dart
ElevatedButton(
    onPressed: () async {
        final bytes = await compressFile();

        // Might throw a SecurityError if compressFile() has taken too long to execute.
        FlutterFileSaver().writeFileAsBytes(bytes: bytes, fileName: myFileName);
    },
    child: const Text('Save File'),
),
```

The fix is to call `writeFileAsBytes`/`writeFileAsString` immediately after a user interaction. For example, by having a two-phase save flow with a button specifically made to save the file:

```dart
ElevatedButton(
    onPressed: () async {
        // 1st phase: compress the file
        final bytes = await compressFile();

        if (!context.mounted) return;
        // 2nd phase: show a dialog to save the file
        showDialog(context: context, builder: (_) => DownloadDialog(bytes: bytes, fileName: myFileName));
    },
    child: const Text('Save File'),
),


class DownloadDialog extends StatelessWidget {
    const DownloadDialog({super.key, required this.bytes, required this.fileName});

    final Uint8List bytes;
    final String fileName;

    @override
    Widget build(BuildContext context) {
        return AlertDialog(
            title: const Text('Save File'),
            content: const Text('Do you want to save the file?'),
            actions: [
                TextButton(
                    onPressed: () {
                        // Will work because it is called immediately after a user interaction.
                        FlutterFileSaver().writeFileAsBytes(bytes: bytes, fileName: fileName);
                        Navigator.pop(context);
                    },
                    child: const Text('Save'),
                ),
            ],
        );
    }
}

```