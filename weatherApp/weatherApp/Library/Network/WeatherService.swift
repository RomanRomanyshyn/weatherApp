//
//  WeatherService.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 09.08.2022.
//

import Foundation
import CoreLocation

enum WeatherService {
    case forecast(location: CLLocationCoordinate2D)
    case search(text: String)
    
    private enum Constants {
        static let apiKey = "2846fe00739a331b86a5a6a8349cd0df"
        static let searchResultsLimit: Int = 5
        static let units = "metric"
    }
}

extension WeatherService: Service {
    var baseURL: String {
        "https://api.openweathermap.org"
    }
    
    var path: String {
        switch self {
        case .forecast:
            return "/data/2.5/forecast"
        case .search:
            return "/geo/1.0/direct"
        }
    }
    
    var parameters: [String: String] {
        var parameters: [String: String] = [
            "appid": Constants.apiKey
        ]
        switch self {
        case .forecast(let location):
            parameters["lat"] = String(location.latitude)
            parameters["lon"] = String(location.longitude)
            parameters["units"] = Constants.units
        case .search(let searchText):
            parameters["q"] = searchText
            parameters["limit"] = String(Constants.searchResultsLimit)
        }
        return parameters
    }
    
    var method: ServiceMethod {
        .get
    }
    
    
}
