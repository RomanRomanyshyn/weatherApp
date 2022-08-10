//
//  WeatherResponse.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 09.08.2022.
//

import Foundation

// MARK: - WeatherResponse

struct WeatherResponse: Codable {
    let list: [WeatherItem]
    let city: City
}

// MARK: - City

struct City: Codable {
    let id: Int
    let name: String
    let coordinates: Coordinates
    let country: String
    let population, timezone, sunrise, sunset: Int
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case id, name, country, population, timezone, sunrise, sunset
    }
}
// MARK: - Coordinates

struct Coordinates: Codable {
    let lat, lon: Double
}
//
// MARK: - WeatherItem

struct WeatherItem: Codable {
    let timestamp: Int
    var time: String
    let main: MainForecastInfo
    let weather: [Weather]
    let wind: Wind
    let precipitation: Double
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case time = "dt_txt"
        case precipitation = "pop"
        case wind, main, weather
    }
}
//
// MARK: - MainClass

struct MainForecastInfo: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Wind

struct Wind: Codable {
    let speed: Double
    let direction: Int
    let gust: Double
    
    enum CodingKeys: String, CodingKey {
        case direction = "deg"
        case speed, gust
    }
}
