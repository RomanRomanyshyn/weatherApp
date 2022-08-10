//
//  ServiceProvider.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import Foundation
import PromiseKit
import PMKFoundation

enum NetworkError: Error {
    case withStatusCode(_ statusCode: Int)
    case unknown
}

final class ServiceProvider {
    
    private typealias DataTaskResult = (data: Data, response: URLResponse)

    private let urlSession = URLSession.shared
    private let queue = DispatchQueue.global(qos: .background)

    init() {}
    
    func start<T: Codable>(request: Service, type: T.Type) -> Promise<T> {
        firstly {
            sendRequest(request.urlRequest)
        }.then { response in
            self.validateResponse(response)
        }.then { data in
            self.decode(data: data, type: T.self)
        }
    }
}

extension ServiceProvider {
    private func sendRequest(_ urlRequest: URLRequest) -> Promise<DataTaskResult> {
        Promise<DataTaskResult> { seal in
            queue.async {
                URLSession.shared.dataTask(.promise, with: urlRequest)
                    .done { value in
                        seal.fulfill(value)
                    }.catch { error in
                        seal.reject(error)
                    }
            }
        }
    }
    
    private func validateResponse(_ result: DataTaskResult) -> Promise<Data> {
        return Promise { seal in
            guard let response = result.response as? HTTPURLResponse else {
                seal.reject(NetworkError.unknown)
                return
            }

            switch response.statusCode {
            case 200..<300:
                seal.fulfill(result.data)
            default:
                seal.reject(NetworkError.withStatusCode(response.statusCode))
            }
        }
    }
    
    private func decode<T: Codable>(data: Data, type: T.Type) -> Promise<T> {
        Promise { seal in
            do {
                seal.fulfill(try JSONDecoder().decode(T.self, from: data))
            } catch {
                seal.reject(error)
            }
        }
    }
}

extension ServiceProvider {
    func loadImage(_ url: URL) -> Promise<Data> {
        Promise { seal in
            queue.async {
                URLSession.shared.dataTask(.promise, with: url)
                    .done { value in
                        seal.fulfill(value.data)
                    }.catch { error in
                        seal.reject(error)
                    }
            }
        }
    }
    
    func loadImage(_ name: String) -> Promise<Data> {
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(name)@4x.png") else {
            return Promise { $0.reject(NetworkError.unknown)}
        }
        return loadImage(url)
    }
}
