//
//  HomePresenter.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit
import CoreLocation
import PromiseKit

final class HomePresenter: NSObject, PresenterProtocol {
    
    // MARK: - Typealiases
    
    typealias View = HomeViewProtocol
    typealias Coordinator = HomeCoordinatorProtocol
    typealias Parameters = Void
    
    // MARK: - Properties
    
    weak var view: View?
    weak var coordinator: Coordinator?
    
    private let provider = ServiceProvider()
    private var dataSource = [[WeatherItem]]()
    
    private var selectedDayIndex: Int {
        view?.tableView.indexPathForSelectedRow?.row ?? .zero
    }

    // MARK: - Constants
    
    private enum Constants {
        static let tableCellType = WeatherTableCell.self
        static let collectionCellType = WeatherCollectionCell.self
    }
    
    // MARK: - Init
    
    init(parameters: Void, view: View, coordinator: Coordinator) {
        self.view = view
        self.coordinator = coordinator
    }
    
    // MARK: - Private
    
    private func configureTableView() {
        view?.tableView.registerXibCell(Constants.tableCellType)
        view?.tableView.delegate = self
        view?.tableView.dataSource = self
    }
    
    private func configureCollectionView() {
        view?.collectionView.registerXibCell(Constants.collectionCellType)
        view?.collectionView.dataSource = self
    }

    private func loadForecast() {
        provider.start(request: WeatherService.forecast(
            location: CLLocationCoordinate2D(latitude: 49.835070,
                                             longitude: 24.023791)),
            type: WeatherResponse.self)
        .then{ model in
            self.updateMainView(model: model)
        }.then { model in
            self.setDay(for: model.list)
        }.then { model in
            self.groupByDays(model)
        }.done { groupedModel in
            self.dataSource = groupedModel
            self.view?.tableView.reloadData()
            self.view?.collectionView.reloadData()
            self.view?.tableView.selectRow(at: IndexPath(item: .zero, section: .zero),
                                           animated: false,
                                           scrollPosition: .top)
        }.catch { error in
            print(error)
        }
    }
    
    private func updateMainView(model: WeatherResponse) -> Promise<WeatherResponse> {
        guard let weather = model.list.first else { return Promise { $0.fulfill(model) } }

        let tempMin = String(Int(round(weather.main.tempMin)))
        let tempMax = String(Int(round(weather.main.tempMax)))
        let temp = "\(tempMin) \\ \(tempMax)º"
        let humidity = "\(weather.main.humidity)%"
        let wind = "\(String(weather.wind.speed)) м/c"
        
        view?.setMainInfo(temp: temp, humidity: humidity, wind: wind)
        view?.set(title: model.city.name)
        provider.loadImage(weather.weather.first?.icon ?? "")
            .done { data in
                let image = UIImage(data: data)
                self.view?.setMainImage(image)
            }.catch { error in
                print(error)
            }
        return Promise { $0.fulfill(model) }
    }
    
    private func setDay(for items: [WeatherItem]) -> Promise<[WeatherItem]> {
        Promise { seal in
            let formatter = CustomDateFormatter.shared.date
            let modifiedItems: [WeatherItem] = items.compactMap {
                var newItem = $0
                let date = Date(timeIntervalSince1970: TimeInterval($0.timestamp))
                newItem.time = formatter.string(from: date)
                return newItem
            }
            
            seal.fulfill(modifiedItems)
        }
    }
    
    private func hour(for item: WeatherItem) -> String {
        let formatter = CustomDateFormatter.shared.hour
        let date = Date(timeIntervalSince1970: TimeInterval(item.timestamp))
        return formatter.string(from: date)
    }
    
    private func groupByDays(_ items: [WeatherItem]) -> Promise<[[WeatherItem]]> {
        Promise {
            let dictionary = Dictionary(grouping: items, by: { $0.time })
                .sorted { $0.key < $1.key }

            $0.fulfill(dictionary.compactMap { $0.value })
        }
    }
    
    // MARK: - Public
    
    func onViewDidLoad() {
        configureTableView()
        configureCollectionView()
        
        loadForecast()
    }
}

// MARK: - HomePresenterProtocol

extension HomePresenter: HomePresenterProtocol {
    func map() {
        coordinator?.map()
    }
    
    func searchList() {
        coordinator?.searchList()
    }
}

// MARK: - UICollectionViewDataSource

extension HomePresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource[safe: selectedDayIndex]?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(class: Constants.collectionCellType, for: indexPath) else {
            return UICollectionViewCell()
        }
        
        let item = dataSource[selectedDayIndex][indexPath.row]
        
        cell.configure(hour: hour(for: item), temperature: Int(round(item.main.temp)), image: UIImage())

        return cell
    }
}

// MARK: - UITableView methods

extension HomePresenter: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(class: Constants.tableCellType, for: indexPath) else {
            return UITableViewCell()
        }
        let item = dataSource[indexPath.row]
        let date = Date(timeIntervalSince1970: TimeInterval(item[0].timestamp))
        let day = CustomDateFormatter.shared.day.string(from: date)
        let tempMin = item
            .compactMap { $0.main.tempMin }
            .min() ?? .zero
        let tempMax = item
            .compactMap { $0.main.tempMax }
            .max() ?? .zero
        
        cell.configure(day: day,
                       tempMin: Int(round(tempMin)),
                       tempMax: Int(round(tempMax)),
                       image: UIImage())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view?.collectionView.reloadData()
    }
}
