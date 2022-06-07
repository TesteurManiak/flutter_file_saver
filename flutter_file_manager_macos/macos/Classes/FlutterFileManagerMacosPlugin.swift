import Cocoa
import FlutterMacOS

public class FlutterFileManagerMacosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_file_manager_macos", binaryMessenger: registrar.messenger)
        let instance = FlutterFileManagerMacosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "writeFile":
            handleWriteFile(result, call)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func handleWriteFile(_ result: FlutterResult, _ call: FlutterMethodCall) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let name = args["name"] as? String,
           let flutterBytes = args["bytes"] as? FlutterStandardTypedData {
            let data = Data(flutterBytes.data)
            let _ = [UInt8](data)
            result(name)
        } else {
            result(FlutterError.init(code: "Bad arguments", message: nil, details: nil))
        }
    }
}
