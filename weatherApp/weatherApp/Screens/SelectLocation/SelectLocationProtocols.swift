//
//  MapScreenProtocols.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit
import MapKit
import CoreLocation

protocol SelectLocationViewProtocol: AnyObject {
    func set(region: MKCoordinateRegion)
    func present(alert: UIAlertController)
}

protocol SelectLocationPresenterProtocol: BasePresenterProtocol {
    func showWeather(for location: CLLocationCoordinate2D)
}

protocol SelectLocationCoordinatorProtocol: AbstractCoordinatorProtocol {}
