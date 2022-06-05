# flutter_file_saver

[![Pub Version](https://img.shields.io/pub/v/flutter_file_saver)](https://pub.dev/packages/flutter_file_saver)

Interface to provide a way to save files on the device in Flutter.

## Setup

### Android

In your `android/app/src/main/AndroidManifest.xml`, add the `WRITE_EXTERNAL_STORAGE`, `MANAGE_EXTERNAL_STORAGE` permissions and the `android:requestLegacyExternalStorage="true"`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.example.my_app">
    <!-- ... -->

    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />

    <application android:requestLegacyExternalStorage="true" android:label="MyApp" android:name="${applicationName}" android:icon="@mipmap/ic_launcher">
        <!-- ... -->
    </application>
</manifest>
```

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

### MacOS

Add the following permissions to your `macOS/Runner/DebugProfile.entitlements`:

```xml
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```