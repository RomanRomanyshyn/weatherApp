//
//  SelectLocationPresenter.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit
import CoreLocation
import MapKit

final class SelectLocationPresenter: PresenterProtocol {
    
    // MARK: - Typealiases
    
    typealias View = SelectLocationViewProtocol
    typealias Coordinator = SelectLocationCoordinatorProtocol
    typealias Parameters = SearchWeatherHandler
    
    // MARK: - Properties
    
    weak var view: View?
    weak var coordinator: Coordinator?
    
    private weak var delegate: SearchWeatherHandler?
    private let locationManager = LocationManager.shared
    private let notificationCenter = NotificationCenter.default

    private var location: CLLocationCoordinate2D? {
        didSet {
            guard let location = location else { return }
            updateUI(with: location)
        }
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let spanDelta: CLLocationDegrees = 0.02
    }
    
    // MARK: - Init
    
    init(parameters: SearchWeatherHandler, view: View, coordinator: Coordinator) {
        self.view = view
        self.coordinator = coordinator
        self.delegate = parameters
    }
    
    // MARK: - Private
    
    private func configureLocationManager() {
        locationManager.checkLocationService()
        observeNotification()
        
        notificationCenter.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                       object: nil,
                                       queue: .main) {
            [weak self] _ in
            if self?.location == nil {
                self?.locationManager.checkLocationService()
            }
        }
    }
    
    private func observeNotification() {
        notificationCenter.addObserver(forName: .sharedLocation,
                                       object: nil,
                                       queue: .main) {
            [weak self] notification in
            guard let self = self else { return }
            guard let result = notification.object as? LocationResult  else { return }
            
            switch result {
            case .failure:
                self.location = nil
                self.view?.present(alert: UIAlertController.locationErrorVC)
            case .success(let cLLocation):
                if self.location == nil {
                    self.location = cLLocation.coordinate
                }
            }
        }
    }
    
    private func updateUI(with location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: Constants.spanDelta,
                                    longitudeDelta: Constants.spanDelta)
        let region = MKCoordinateRegion(center: location,
                                        span: span)
        self.view?.set(region: region)
    }
    
    // MARK: - Public
    
    func onViewDidLoad() {
        configureLocationManager()
    }
}

// MARK: - SelectLocationPresenterProtocol

extension SelectLocationPresenter: SelectLocationPresenterProtocol {
    func showWeather(for location: CLLocationCoordinate2D) {
        delegate?.update(with: location)
        coordinator?.goBack()
    }
}
