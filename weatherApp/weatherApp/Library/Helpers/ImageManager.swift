//
//  ImageManager.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 09.08.2022.
//

import UIKit
import PromiseKit

final class ImageManager {
    
    // MARK: - Errors
    
    enum ImageError: Error {
        case noPath
        case noImage
        case wrongUrl
        case cannotConvertToPng
        case cannotCreateFilePath
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let plistName = "cachedImages.plist"
    }
    
    // MARK: - Properties
    
    private let requestManager = ServiceProvider()
    private let fileManager = FileManager.default
    private lazy var plistManager = PlistManager(CachedImage.self, fileURL: fileURL)
    
    private var fileURL: URL? = {
        let manager = FileManager.default
        var url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url?.appendingPathComponent(Constants.plistName)
    }()
    
    // MARK: - Init
    
    init() {}
    
    // MARK: - Public
    
    func image(for stringUrl: String) -> Promise<UIImage> {
        Promise { seal in
            firstly {
                validateURL(stringUrl)
            }.then{ url in
                self.image(for: url)
            }.done { image in
                seal.fulfill(image)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    // MARK: - Private
    
    private func image(for url: URL) -> Promise<UIImage> {
        Promise { seal in
            firstly {
                self.imageFromCache(url: url)
            }.done { image in
                seal.fulfill(image)
            }.catch { error in
                self.handleLocalError(seal: seal, url: url)
            }
        }
    }
    
    private func imageFromCache(url: URL) -> Promise<UIImage> {
        Promise { seal in
            firstly {
                plistManager.get(where: { $0.url == url })
            }.map{ cachedImage in
                return cachedImage.path
            }.then { path in
                self.fileManager.savedDataFromFile(path)
            }.then { data in
                self.image(from: data)
            }.done { image in
                seal.fulfill(image)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    private func handleLocalError(seal: Resolver<UIImage>, url: URL) {
        firstly {
            requestManager.loadImage(url)
        }.then { data in
            self.image(from: data)
        }.get { image in
            self.cacheImage(image: image, url: url)
        }.done { image in
            seal.fulfill(image)
        }.catch { error in
            seal.reject(error)
        }
    }
    
    private func cacheImage(image: UIImage, url: URL) {
        firstly {
            data(for: image)
        }.then { data in
            self.fileManager.saveDataToFile(data)
        }.then { filePath in
            self.plistManager.save(CachedImage(url: url, path: filePath))
        }.cauterize()
    }
    
    private func validateURL(_ stringURL: String) -> Promise<URL> {
        Promise { seal in
            if let url = URL(string: stringURL) {
                seal.fulfill(url)
            } else {
                seal.reject(ImageError.wrongUrl)
            }
        }
    }
    
    // MARK: - Decode
    
    private func image(from data: Data) -> Promise<UIImage> {
        Promise { seal in
            do {
                if let image = UIImage(data: data) {
                    seal.fulfill(image)
                } else {
                    throw ImageError.noImage
                }
            } catch {
                seal.reject(error)
            }
        }
    }
    
    // MARK: - Encode
    
    private func data(for image: UIImage) -> Promise<Data> {
        Promise { seal in
            if let pngRepresentation = image.pngData() {
                seal.fulfill(pngRepresentation)
            } else {
                seal.reject(ImageError.cannotConvertToPng)
            }
        }
    }
}

struct CachedImage: Codable {
    let url: URL
    let path: URL
}
