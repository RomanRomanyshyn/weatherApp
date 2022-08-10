//
//  PlistManager.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 09.08.2022.
//

import Foundation
import PromiseKit

final class PlistManager<T: Codable> {
    
    // MARK: - Errors
    
    enum PlistError: Error {
        case noPath
        case wrongPath
    }
    
    // MARK: - Properties
    
    private let type: T.Type
    private let filePath: URL?
    private let queue = DispatchQueue(label: "weather_plist_queue", qos: .userInitiated)
    
    // MARK: - Init
    
    init(_ type: T.Type, fileURL: URL?) {
        self.type = type
        self.filePath = fileURL
    }
    
    // MARK: - Public
    
    func save(_ item: T) -> Promise<Void> {
        Promise { seal in
            firstly {
                validateFilePath()
            }.then{ filepath in
                self.save(item, filepath: filepath)
            }.done { _ in
                seal.fulfill(())
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func get(where predicate: @escaping (T) -> Bool) -> Promise<T> {
        Promise { seal in
            firstly {
                validateFilePath()
            }.then{ filepath in
                self.read(filepath: filepath)
            }.then { cache in
                self.first(from: cache, where: predicate)
            }.done { item in
                seal.fulfill(item)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    // MARK: - Private
    
    private func save(_ item: T, filepath: URL) -> Promise<Void> {
        Promise { seal in
            firstly {
                read(filepath: filepath)
            }.then { cache in
                self.append(item, to: cache)
            }.then { newCache in
                self.write(newCache, filepath: filepath)
            }.done { _ in
                seal.fulfill(())
            }.catch { error in
                seal.reject(error)
            }
        }
    }
        
    private func read(filepath: URL) -> Promise<[T]> {
        Promise { seal in
            queue.async {
                do {
                    let data = try Data(contentsOf: filepath)
                    let decoder = PropertyListDecoder()
                    let cache = try decoder.decode([T].self, from: data)
                    seal.fulfill(cache)
                } catch let error {
                    seal.reject(error)
                }
            }
        }
    }
    
    private func write(_ cache: [T], filepath: URL) -> Promise<Void> {
        Promise { seal in
            queue.async {
                do {
                    let encoder = PropertyListEncoder()
                    let encodedData = try encoder.encode(cache)
                    try encodedData.write(to: filepath)
                    seal.fulfill(())
                } catch {
                    seal.reject(error)
                }
            }
        }
    }
    
    private func validateFilePath() -> Promise<URL> {
        Promise { seal in
            if let filePath = filePath {
                seal.fulfill(filePath)
            } else {
                seal.reject(PlistError.noPath)
            }
        }
    }
    
    private func first(from cache: [T], where predicate: (T) -> Bool) -> Promise<T> {
        Promise { seal in
            if let cachedImage = cache.first(where: predicate) {
                seal.fulfill(cachedImage)
            } else {
                seal.reject(PlistError.noPath)
            }
        }
    }
    
    private func append(_ cachedItem: T, to cache: [T]) -> Promise<[T]> {
        Promise { seal in
            var new = cache
            new.append(cachedItem)
            seal.fulfill(new)
        }
    }
}
