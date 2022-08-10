//
//  CityCell.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 10.08.2022.
//

import UIKit

class CityCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let label = UILabel()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addLabel()
    }
    
    // MARK: - Private
    
    private func addLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        
        label.layoutIfNeeded()
    }
    
    // MARK: - Public
    
    func configure(with city: SearchedCity) {
        label.text = "\(city.name), \(city.country)"
    }
}
