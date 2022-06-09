# flutter_file_saver

[![Pub Version](https://img.shields.io/pub/v/flutter_file_saver)](https://pub.dev/packages/flutter_file_saver)

Interface to provide a way to save files on the device in Flutter.

## Platform Support

| | Android | iOS | Web | Windows | Linux | MacOS |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| `writeFileAsBytes` | ✅ | ✅ | ✅  | ❌️ | ❌️ | ✅ |
| `writeFileAsString` | ✅ | ✅ | ✅  | ❌️ | ❌️ | ✅ |

## Setup

### Import the package

```yaml
dependencies:
    flutter_file_saver: any
```

### Android

```gradle
android {
    defaultConfig {
        minSdkVersion 19
    }
}
```

[Check example](https://github.com/TesteurManiak/flutter_file_saver/blob/main/flutter_file_saver/example/android/app/build.gradle)

### iOS

Add the following permissions to your `ios/Runner/Info.plist`:

```xml
<key>UISupportsDocumentBrowser</key>
<true/>
<key>UIFileSharingEnabled</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

[Check example](https://github.com/TesteurManiak/flutter_file_saver/blob/main/flutter_file_saver/example/ios/Runner/Info.plist)

### MacOS (Only for MacOS 10.9 and above)

Add the following permissions to your `macos/Runner/DebugProfile.entitlements`:

```xml
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

[Check example](https://github.com/TesteurManiak/flutter_file_saver/blob/main/flutter_file_saver/example/macos/Runner/DebugProfile.entitlements)

## Todo

* Support for Windows & Linux
* Support custom local paths