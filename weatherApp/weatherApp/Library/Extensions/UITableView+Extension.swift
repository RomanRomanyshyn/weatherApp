//
//  UITableView+Extension.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(class: T.Type, for indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)

        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T
    }

    func dequeueReusableCell<T: UITableViewCell>(class: T.Type) -> T? {
        let identifier = String(describing: T.self)
        
        return self.dequeueReusableCell(withIdentifier: identifier) as? T
    }
    
    func registerXibCell<T: UITableViewCell>(_ class: T.Type) {
        let name = String(describing: T.self)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellReuseIdentifier: name)
    }
    
    func registerCell<T: UITableViewCell>(_ class: T.Type) {
        let name = String(describing: T.self)
        self.register(T.self, forCellReuseIdentifier: name)
    }
}
