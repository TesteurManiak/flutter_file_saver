// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "flutter_file_manager_macos",
  platforms: [
    .macOS("10.14")
  ],
  products: [
    .library(name: "flutter-file-manager-macos", targets: ["flutter_file_manager_macos"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "flutter_file_manager_macos",
      dependencies: []
    )
  ]
)
