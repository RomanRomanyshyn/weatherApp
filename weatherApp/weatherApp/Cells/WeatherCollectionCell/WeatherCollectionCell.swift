//
//  WeatherCollectionCell.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 09.08.2022.
//

import UIKit

final class WeatherCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    
    private let provider = ServiceProvider()
    
    func configure(hour: String, temperature: Int, imageName: String) {
        self.hourLabel.text = hour
        self.temperatureLabel.text = "\(temperature)º"
        provider.loadImage(imageName)
            .done { data in
                self.weatherImageView.image = UIImage(data: data)
            }.cauterize()
    }
}
