//
//  HomePresenter.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit
import CoreLocation
import PromiseKit
import SkeletonView

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
        static let lvivCoordinates = CLLocationCoordinate2D(latitude: 49.835070,
                                                            longitude: 24.023791)
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
        
        view?.tableView.isSkeletonable = true
    }
    
    private func configureCollectionView() {
        view?.collectionView.registerXibCell(Constants.collectionCellType)
        view?.collectionView.dataSource = self
        view?.collectionView.isSkeletonable = true

    }

    private func loadForecast(location: CLLocationCoordinate2D) {
        view?.tableView.showAnimatedGradientSkeleton()
        view?.collectionView.showAnimatedGradientSkeleton()

        provider.start(request: WeatherService.forecast(location: location),
                       type: WeatherResponse.self)
        .get { result in
            self.updateMainView(model: result)
        }.then { result in
            self.setDay(for: result.list)
        }.then { model in
            self.groupByDays(model)
        }.done { groupedModel in
            self.set(dataSource: groupedModel)
        }.catch { error in
            print(error)
        }
    }
    
    private func updateMainView(model: WeatherResponse) {
        guard let weather = model.list.first else { return }

        let tempMin = String(Int(round(weather.main.tempMin)))
        let tempMax = String(Int(round(weather.main.tempMax)))
        let temp = "\(tempMin) \\ \(tempMax)º"
        let humidity = "\(weather.main.humidity)%"
        let wind = "\(String(weather.wind.speed)) м/c"
        
        view?.setMainInfo(temp: temp, humidity: humidity, wind: wind)
        view?.set(title: model.city.name)
        provider.loadImage(weather.weather.first?.icon ?? "")
            .done { image in
                self.view?.setMainImage(image)
            }.cauterize()
    }
    
    private func setDay(for items: [WeatherItem]) -> Guarantee<[WeatherItem]> {
        Guarantee { seal in
            let formatter = CustomDateFormatter.shared.date
            let modifiedItems: [WeatherItem] = items.compactMap {
                var newItem = $0
                let date = Date(timeIntervalSince1970: TimeInterval($0.timestamp))
                newItem.time = formatter.string(from: date)
                return newItem
            }
            
            seal(modifiedItems)
        }
    }
    
    private func groupByDays(_ items: [WeatherItem]) -> Guarantee<[[WeatherItem]]> {
        Guarantee {
            let dictionary = Dictionary(grouping: items, by: { $0.time })
                .sorted { $0.key < $1.key }

            $0(dictionary.compactMap { $0.value })
        }
    }
    
    private func set(dataSource: [[WeatherItem]]) {
        self.dataSource = dataSource
        view?.tableView.reloadData()
        view?.tableView.hideSkeleton()
        view?.collectionView.reloadData()
        view?.collectionView.hideSkeleton()
        view?.tableView.selectRow(at: IndexPath.zero, animated: false, scrollPosition: .top)
    }
    
    private func hour(for item: WeatherItem) -> String {
        let formatter = CustomDateFormatter.shared.hour
        let date = Date(timeIntervalSince1970: TimeInterval(item.timestamp))
        return formatter.string(from: date)
    }
    
    // MARK: - Public
    
    func onViewDidLoad() {
        configureTableView()
        configureCollectionView()
        
        loadForecast(location: Constants.lvivCoordinates)
    }
}

// MARK: - HomePresenterProtocol

extension HomePresenter: HomePresenterProtocol {
    func map() {
        coordinator?.map(handler: self)
    }
    
    func searchList() {
        coordinator?.searchList(handler: self)
    }
}

// MARK: - SearchWeatherHandler

extension HomePresenter: SearchWeatherHandler {
    func update(with coordinates: CLLocationCoordinate2D) {
        loadForecast(location: coordinates)
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
        
        cell.configure(hour: hour(for: item),
                       temperature: Int(round(item.main.temp)),
                       imageName: item.weather.first?.icon ?? "")

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
        
        let imageName = item.first?.weather.first?.icon ?? ""
        
        cell.configure(day: day,
                       tempMin: Int(round(tempMin)),
                       tempMax: Int(round(tempMax)),
                       imageName: imageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view?.collectionView.reloadData()
    }
}

// MARK: - Skeleton

extension HomePresenter: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        String(describing: Constants.tableCellType)
    }
}

extension HomePresenter: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        String(describing: Constants.collectionCellType)
    }
}
