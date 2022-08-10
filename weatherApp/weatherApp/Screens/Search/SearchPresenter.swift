//
//  SearchPresenter.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit
import CoreLocation

final class SearchPresenter: NSObject, PresenterProtocol {
    
    // MARK: - Typealiases
    
    typealias View = SearchViewProtocol
    typealias Coordinator = SearchCoordinatorProtocol
    typealias Parameters = SearchWeatherHandler
    
    // MARK: - Properties
    
    weak var view: View?
    weak var coordinator: Coordinator?
    
    private let provider = ServiceProvider()
    private var dataSource = [SearchedCity]()
    private weak var delegate: SearchWeatherHandler?
    
    // MARK: - Constants
    
    private enum Constants {
        static let cellType = CityCell.self
    }
    
    // MARK: - Init
    
    init(parameters: SearchWeatherHandler, view: View, coordinator: Coordinator) {
        self.view = view
        self.coordinator = coordinator
        self.delegate = parameters
    }
    
    // MARK: - Private
    
    private func configureTableView() {
        view?.tableView.registerCell(Constants.cellType)
        view?.tableView.delegate = self
        view?.tableView.dataSource = self
    }
    
    private func loadCities(_ searchText: String) {
        provider.start(request: WeatherService.search(text: searchText),
                       type: [SearchedCity].self)
        .done { model in
            self.dataSource = model
            self.dataSource += model
            self.dataSource += model
            self.view?.tableView.reloadData()
        }.catch { error in
            print(error)
        }
    }
    
    // MARK: - Public
    
    func onViewDidLoad() {
        configureTableView()
    }
}

// MARK: - SearchPresenterProtocol

extension SearchPresenter: SearchPresenterProtocol {
    func search(_ text: String) {
        loadCities(text)
    }
    
    func back() {
        coordinator?.goBack()
    }
}

// MARK: - UITableView methods

extension SearchPresenter: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(class: Constants.cellType, for: indexPath) else {
            return UITableViewCell()
        }
        
        cell.configure(with: dataSource[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = dataSource[indexPath.row]
        let coordinates = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon)
        delegate?.update(with: coordinates)
        coordinator?.goBack()
    }
}

protocol SearchWeatherHandler: AnyObject {
    func update(with coordinates: CLLocationCoordinate2D)
}
