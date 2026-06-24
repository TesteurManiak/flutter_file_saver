import Cocoa
import FlutterMacOS

public class FlutterFileManagerMacosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger
        let api = MacOSMessageHandler()
        MacOSMessageApiSetup.setUp(binaryMessenger: messenger, api: api)
    }
}
