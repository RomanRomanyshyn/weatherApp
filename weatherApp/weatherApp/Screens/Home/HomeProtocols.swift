//
//  HomeProtocols.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    var tableView: UITableView! { get }
    var collectionView: UICollectionView! { get }
    
    func setMainInfo(temp: String, humidity: String, wind: String)
    func setMainImage(_ image: UIImage?)
    func set(title: String)
}

protocol HomePresenterProtocol: BasePresenterProtocol {
    func map()
    func searchList()
}

protocol HomeCoordinatorProtocol: AbstractCoordinatorProtocol {
    func map(handler: SearchWeatherHandler)
    func searchList(handler: SearchWeatherHandler)
}
