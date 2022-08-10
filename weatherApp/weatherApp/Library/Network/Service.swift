//
//  Service.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import Foundation

enum ServiceMethod: String {
    case get = "GET"
}

protocol Service {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var method: ServiceMethod { get }
}

extension Service {
    var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError("URL could not be built")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        return request
    }

    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path

        switch method {
        case .get:
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        return urlComponents?.url
    }
}

