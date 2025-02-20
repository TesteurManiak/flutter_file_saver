//
//  MacOSMessageHandler.swift
//  Pods
//
//  Created by Guillaume Roux on 20/02/2025.
//

import FlutterMacOS

class MacOSMessageHandler: MacOSMessageApi {
    func writeFile(fileName: String, bytes: FlutterStandardTypedData, completion: @escaping (Result<String, any Error>) -> Void) {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = fileName
        savePanel.begin { (saveResult) in
            guard saveResult == .OK, let path = savePanel.url else {
                completion(.failure(PigeonError.init(code: "CANCELLED", message: nil, details: nil)))
                return
            }
            do {
                let content = Data(bytes.data)
                try content.write(to: path)
                completion(.success(path.path))
            } catch {
                completion(.failure(PigeonError.init(code: "FAILED", message: "Error while writing file \(fileName)", details: error.localizedDescription)))
            }
        }
    }
}
