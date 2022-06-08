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

### Android (Only for Android 10 and above)

In your `android/app/src/main/AndroidManifest.xml`, add:
* `WRITE_EXTERNAL_STORAGE`,
* `MANAGE_EXTERNAL_STORAGE`,
* `android:requestLegacyExternalStorage="true"`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.example.my_app">
    <!-- ... -->

    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />

    <application android:requestLegacyExternalStorage="true" android:label="MyApp" android:name="${applicationName}">
        <!-- ... -->
    </application>
</manifest>
```

[Check example](https://github.com/TesteurManiak/flutter_file_saver/blob/main/flutter_file_saver/example/android/app/src/main/AndroidManifest.xml)

**Permission request is managed by the package.**

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