//
//  WeatherTableCell.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 09.08.2022.
//

import UIKit

final class WeatherTableCell: UITableViewCell {
    
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    
    private let provider = ServiceProvider()
    
    func configure(day: String, tempMin: Int, tempMax: Int, imageName: String) {
        self.dayLabel.text = day
        self.temperatureLabel.text = "\(tempMax)º \\ \(tempMin)º"
        provider.loadImage(imageName)
            .done { data in
                self.weatherImageView.image = UIImage(data: data)
            }.cauterize()
    }
}
