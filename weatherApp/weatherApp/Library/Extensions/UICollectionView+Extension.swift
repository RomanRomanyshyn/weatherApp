//
//  UICollectionView+Extension.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit

extension UICollectionView {
    
    // MARK: - Cell
    
    func dequeueReusableCell<T: UICollectionViewCell>(class: T.Type, for indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)
        
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T
    }

    func registerXibCell<T: UICollectionViewCell>(_ class: T.Type) {
        let name = String(describing: T.self)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: name)
    }
    
    func registerCell<T: UICollectionViewCell>(_ class: T.Type) {
        let name = String(describing: T.self)
        self.register(T.self, forCellWithReuseIdentifier: name)
    }
    
    // MARK: - ReusableView
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(class: T.Type, ofKind kind: String, for indexPath: IndexPath) -> T? {
        let identifier = String(describing: T.self)
        
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T
    }
    
    func registerReusableXibView<T: UICollectionReusableView>(_ class: T.Type, ofKind kind: String) {
        let name = String(describing: T.self)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
    }
    
    func registerReusableView<T: UICollectionReusableView>(_ class: T.Type, ofKind kind: String) {
        let name = String(describing: T.self)
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
    }
}
