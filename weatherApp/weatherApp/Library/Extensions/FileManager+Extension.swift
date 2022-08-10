//
//  FileManager+Extension.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 09.08.2022.
//

import Foundation
import PromiseKit

extension FileManager {
    
    enum FileManagerError: Error {
        case cannotCreateFilePath
    }
    
    private var uniqueKeyForPath: String {
        let timeInterval = Date().timeIntervalSinceReferenceDate
        return String(timeInterval)
    }
    
    func savedDataFromFile(_ path: URL) -> Promise<Data> {
        Promise { seal in
            do {
                let imageData = try Data(contentsOf: path)
                seal.fulfill(imageData)
            } catch {
                seal.reject(error)
            }
        }
    }
    
    func saveDataToFile(_ data: Data) -> Promise<URL> {
        Promise { seal in
            guard let filePath = uniqueFilePath() else {
                seal.reject(FileManagerError.cannotCreateFilePath)
                return
            }
            do {
                try data.write(to: filePath, options: .atomic)
                seal.fulfill(filePath)
            } catch {
                seal.reject(error)
            }
        }
    }
    
    private func uniqueFilePath() -> URL? {
        let url = try? FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(uniqueKeyForPath + ".png")
        return url
    }
}
