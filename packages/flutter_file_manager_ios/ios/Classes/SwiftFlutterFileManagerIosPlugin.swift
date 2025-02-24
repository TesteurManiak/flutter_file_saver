import Flutter
import UIKit

@available(iOS 16.0, *)
public class SwiftFlutterFileManagerIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      let messenger = registrar.messenger()
      let api = IOSMessageHandler()
      IOSMessageApiSetup.setUp(binaryMessenger: messenger, api: api)
  }
}
