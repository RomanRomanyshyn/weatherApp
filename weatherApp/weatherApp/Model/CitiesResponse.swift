//
//  CitiesResponse.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 10.08.2022.
//

import Foundation

// MARK: - SearchedCity

struct SearchedCity: Codable {
    let name: String
    let localNames: LocalNames?
    let lat, lon: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

// MARK: - LocalNames

struct LocalNames: Codable {
    let fr, uk, en, zh: String?
    let hi, lo: String?
}
