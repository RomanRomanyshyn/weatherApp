//
//  AbstractCoordinator.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit

protocol AbstractCoordinatorProtocol: AnyObject {

    var navigation: UINavigationController { get set }
}

extension AbstractCoordinatorProtocol {
    func push(controller: UIViewController, animated: Bool = true) {
        navigation.pushViewController(controller, animated: animated)
    }

    func present(controller: UIViewController, animated: Bool = true) {
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overCurrentContext
        navigation.present(controller, animated: animated) {
        }
    }
    
    func present(controller: UIViewController,
                 transitionStyle: UIModalTransitionStyle,
                 presentationStyle: UIModalPresentationStyle,
                 animated: Bool = true) {
        controller.modalTransitionStyle = transitionStyle
        controller.modalPresentationStyle = presentationStyle
        navigation.present(controller, animated: animated) {
        }
    }

    func goBack(animated: Bool = true) {
        navigation.popViewController(animated: true)
    }
}
