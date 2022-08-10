//
//  LocationManager.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 10.08.2022.
//

import UIKit
import CoreLocation
import MapKit

extension NSNotification.Name {
    static let sharedLocation = NSNotification.Name("sharedLocation")
}

enum LocationResult {
    case failure
    case success(CLLocation)
}

final class LocationManager: NSObject {
    
    // MARK: - Singleton
    
    static let shared = LocationManager()
    
    // MARK: - Properties
    
    private let manager = CLLocationManager()
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Init
    
    private override init() { }
    
    // MARK: - Public
    
    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationManagerAuthorization()
        } else {
            notifyLocation(with: .failure)
        }
    }
    
    // MARK: - Private
    
    private func setupLocationManager() {
        manager.delegate = self
    }
    
    private func checkLocationManagerAuthorization() {
        switch authorizationStatus() {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
    
        case .denied, .restricted:
            notifyLocation(with: .failure)
        default:
            notifyLocation(with: .failure)
        }
    }
    
    private func authorizationStatus() -> CLAuthorizationStatus {
        var status: CLAuthorizationStatus
        status = CLLocationManager().authorizationStatus
        
        return status
    }
    
    private func notifyLocation(with result: LocationResult) {
        notificationCenter.post(name: .sharedLocation, object: result)
    }
}

// MARK: - CLLocationManagerDelegate methods

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last  else { return }
        DispatchQueue.main.async { [weak self] in
            self?.notifyLocation(with: .success(location))
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationService()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}
