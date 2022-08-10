//
//  ControllerFactory.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit

final class ControllerFactory {
    static func home(coordinator: HomeCoordinatorProtocol) -> HomeViewController {
        let view: HomeViewController = UIStoryboard.main.instantiateViewController()

        let presenter = HomePresenter(parameters: (), view: view, coordinator: coordinator)
        view.presenter = presenter
        
        return view
    }
    
    static func selectLocation(coordinator: SelectLocationCoordinatorProtocol, handler: SearchWeatherHandler) -> SelectLocationViewController {
        let view = SelectLocationViewController()
        let presenter = SelectLocationPresenter(parameters: handler, view: view, coordinator: coordinator)
        view.presenter = presenter

        return view
    }

    static func search(coordinator: SearchCoordinatorProtocol, handler: SearchWeatherHandler) -> SearchViewController {
        let view = SearchViewController()
        let presenter = SearchPresenter(parameters: handler, view: view, coordinator: coordinator)
        view.presenter = presenter

        return view
    }
}
