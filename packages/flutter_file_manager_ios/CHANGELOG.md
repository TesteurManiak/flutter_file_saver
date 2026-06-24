## 3.0.0

* Updates minimum supported SDK version to Flutter 3.44/Dart 3.12.
* Added `meta: ^1.18.0` dependency
* Migrates the iOS plugin from CocoaPods to Swift Package Manager (adds
  `Package.swift`; sources moved under `Sources/`). CocoaPods remains supported.
* Removes the Objective-C registration wrapper; `FlutterFileManagerIosPlugin`
  is now implemented directly in Swift.
* Raises the minimum iOS deployment target to 12.0.

## 2.1.0

* Bumped `flutter_file_manager_platform_interface` to `2.1.0`
* Removed dependency on `path_provider`
* Refactor the code using [pigeon](https://pub.dev/packages/pigeon) to communicate with the native code and use a `UIDocumentPickerViewController` to save the file

## 2.0.0

* Bumped Dart SDK to `3.4.0` and Flutter SDK to `3.22.0`

## 1.1.1

* Fixed pub score
* Upgraded dependencies

## 1.1.0

* Upgraded [flutter_file_manager_platform_interface](https://pub.dev/packages/flutter_file_manager_platform_interface) to version `1.1.0`
* Removed reference to `MimeType`

## 1.0.0

* Initial release
