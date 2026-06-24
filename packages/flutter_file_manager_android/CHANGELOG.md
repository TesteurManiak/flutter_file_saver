## 3.0.0

* Updates minimum supported SDK version to Flutter 3.44/Dart 3.12.
* Migrates to built-in Kotlin (removes `kotlin-android` Gradle plugin and
  `kotlin-gradle-plugin` buildscript classpath); uses
  `kotlin { compilerOptions { jvmTarget } }` block.
* Adds support for Android Gradle Plugin 9.x.
* Converts Android Gradle files to Kotlin DSL (`.gradle.kts`).
* Updates Gradle to 9.1.0, AGP to 9.0.1, Kotlin to 2.3.20, `compileSdk` to 36,
  `jvmTarget` to 17.

## 2.1.0

* Bumped `flutter_file_manager_platform_interface` to `2.1.0`
* Refactor the code using [pigeon](https://pub.dev/packages/pigeon) to communicate with the native code

## 2.0.0+1

* Fixed transitive dependency issue

## 2.0.0

* Bumped Dart SDK to `3.4.0` and Flutter SDK to `3.22.0`

## 1.2.1

* Fixed pub score
* Upgraded dependencies

## 1.2.0+1

* Removed required api Android Q from native code

## 1.2.0

**Minimal API level: 19**

* Use native Android file dialog
* Removed dependency to `permission_handler` (No permission required anymore)

## 1.1.1

* Call to native API to save file in the download folder

## 1.1.0

* Upgraded [flutter_file_manager_platform_interface](https://pub.dev/packages/flutter_file_manager_platform_interface) to version `1.1.0`
* Removed reference to `MimeType`

## 1.0.1

* Updated to version `1.0.2` of [flutter_file_manager_platform_interface](https://pub.dev/packages/flutter_file_manager_platform_interface)

## 1.0.0

* Initial release
