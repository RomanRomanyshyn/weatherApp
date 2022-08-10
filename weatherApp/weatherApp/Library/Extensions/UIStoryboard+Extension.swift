//
//  UIStoryboard+Extension.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit

extension UIStoryboard {

    static var main: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }

    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.indentifier) as? T else {
            fatalError()
        }
        return viewController
    }
}
