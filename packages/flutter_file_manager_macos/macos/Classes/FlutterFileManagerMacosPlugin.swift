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
            let savePanel = NSSavePanel()
            savePanel.nameFieldStringValue = name
            savePanel.begin { (saveResult) in
                guard saveResult == .OK, let path = savePanel.url else {
                    result(FlutterError.init(code: "CANCELLED", message: nil, details: nil))
                    return
                }
                
                do {
                    let content = Data(flutterBytes.data)
                    try content.write(to: path)
                } catch {
                    result(FlutterError.init(code: "FAILED", message: "Error while writing file \(name)", details: error.localizedDescription))
                }
            }
        } else {
            result(FlutterError.init(code: "BAD_ARGS", message: "Bad arguments", details: nil))
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
