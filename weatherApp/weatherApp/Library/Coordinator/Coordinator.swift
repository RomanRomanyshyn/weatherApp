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
    }
    
    func start() {
        let controller = ControllerFactory.home(coordinator: self)
        push(controller: controller)
    }
}

extension Coordinator: HomeCoordinatorProtocol {
    func map() {
        let controller = ControllerFactory.selectLocation(coordinator: self)
        push(controller: controller)
    }
    
    func searchList() {
        let controller = ControllerFactory.search(coordinator: self)
        push(controller: controller)
    }
}

extension Coordinator: SelectLocationCoordinatorProtocol {}

extension Coordinator: SearchCoordinatorProtocol {}
