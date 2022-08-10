//
//  SelectLocationViewController.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit
import MapKit

final class SelectLocationViewController: UIViewController, ViewProtocol {
    
    // MARK: - Typealiases
    
    typealias Presenter = SelectLocationPresenterProtocol
    
    // MARK: - Properties
    
    var presenter: Presenter?
    
    private var button = UIBarButtonItem()
    
    private let mapView = MKMapView()
    private var selectedPoint: CLLocationCoordinate2D? {
        didSet { button.isEnabled = selectedPoint != nil }
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Choose location"
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        addMap()
        addDoneButton()
        addGestureRecognizer()
        
        presenter?.onViewDidLoad()
    }
    
    private func configureView() {
        title = Constants.title
        view.backgroundColor = .white
    }
    
    private func addMap() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.layoutIfNeeded()
    }
    
    private func addDoneButton() {
        button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTap))
        button.isEnabled = false
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func doneButtonDidTap() {
        guard let selectedPoint = selectedPoint else { return }
        presenter?.showWeather(for: selectedPoint)
    }
    
    private func addGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(createNewAnnotation(_:)))
        mapView.addGestureRecognizer(recognizer)
    }
    
    @objc func createNewAnnotation(_ sender: UIGestureRecognizer) {
        let touchPoint = sender.location(in: self.mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        let selectedPoint = MKPointAnnotation()
        selectedPoint.coordinate = coordinates
        selectedPoint.title = "Selected Point"
        mapView.addAnnotation(selectedPoint)
        self.selectedPoint = coordinates
    }
}

// MARK: - SelectLocationViewProtocol

extension SelectLocationViewController: SelectLocationViewProtocol {
    func set(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
    
    func present(alert: UIAlertController) {
        present(alert, animated: true)
    }
}
