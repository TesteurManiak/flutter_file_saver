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