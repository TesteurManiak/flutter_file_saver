//
//  IOSMessageHandler.swift
//  Pods
//
//  Created by Guillaume Roux on 24/02/2025.
//

@available(iOS 16.0, *)
class IOSMessageHandler : NSObject, IOSMessageApi, UIDocumentPickerDelegate {
    var completionHandler: ((Result<String, any Error>) -> Void)?
    
    func writeFile(fileName: String, bytes: FlutterStandardTypedData, completion: @escaping (Result<String, any Error>) -> Void) {
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
            completion(.failure(PigeonError.init(code: "FAILED", message: "No view controller found", details: nil)))
            return
        }
        
        do {
            let tmpUrl = FileManager.default.temporaryDirectory.appending(path: fileName)
            let data = Data(bytes.data)
            try data.write(to: tmpUrl)
            
            let documentPicker = UIDocumentPickerViewController(forExporting: [tmpUrl], asCopy: true)
            documentPicker.delegate = self
            self.completionHandler = completion
            viewController.present(documentPicker, animated: true)
        } catch {
            completion(.failure(PigeonError.init(code: "FAILED", message: "Error while writing file \(fileName)", details: error.localizedDescription)))
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let savedURL = urls.first else {
            completionHandler?(.failure(PigeonError(code: "FAILED", message: "No file selected", details: nil)))
            return
        }
        completionHandler?(.success(savedURL.absoluteString))
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            completionHandler?(.failure(PigeonError(code: "CANCELLED", message: nil, details: nil)))
        }
}
