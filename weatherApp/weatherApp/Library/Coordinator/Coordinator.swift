//
//  Coordinator.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit

final class Coordinator: AbstractCoordinatorProtocol {
    var navigation = UINavigationController()
    
    init(window: UIWindow) {
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        setNavBarAppearance()
    }
    
    private func setNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.shadowColor = .clear
        
        appearance.backgroundColor = UIColor(named: "blue")
        navigation.navigationBar.standardAppearance = appearance
        navigation.navigationBar.scrollEdgeAppearance = appearance
        navigation.navigationBar.compactAppearance = appearance
        navigation.navigationBar.compactScrollEdgeAppearance = appearance
        
        navigation.navigationBar.tintColor = .white
    }
    
    func start() {
        let controller = ControllerFactory.home(coordinator: self)
        push(controller: controller)
    }
}

extension Coordinator: HomeCoordinatorProtocol {
    func map(handler: SearchWeatherHandler) {
        let controller = ControllerFactory.selectLocation(coordinator: self, handler: handler)
        push(controller: controller)
    }
    
    func searchList(handler: SearchWeatherHandler) {
        let controller = ControllerFactory.search(coordinator: self, handler: handler)
        push(controller: controller)
    }
}

extension Coordinator: SelectLocationCoordinatorProtocol {}

extension Coordinator: SearchCoordinatorProtocol {}
