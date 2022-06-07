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
    
    func handleWriteFile(_ result: @escaping FlutterResult, _ call: FlutterMethodCall) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let name = args["name"] as? String,
           let flutterBytes = args["bytes"] as? FlutterStandardTypedData {
            let data = Data(flutterBytes.data)
            let _ = [UInt8](data)
            if #available(macOS 10.12, *) {
                let tmpUrl = FileManager.default.temporaryDirectory
                let fileUrl = tmpUrl.appendingPathComponent(name)
                result(fileUrl)
            } else {
                result(FlutterError.init(code: "2", message: "Not available on MacOs version older than 10.12", details: nil))
            }
        } else {
            result(FlutterError.init(code: "1", message: "Bad arguments", details: nil))
        }
    }
}
