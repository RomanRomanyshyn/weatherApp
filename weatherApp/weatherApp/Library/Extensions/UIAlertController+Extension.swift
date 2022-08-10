//
//  UIAlertController+Extension.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 10.08.2022.
//

import UIKit

extension UIAlertController {
    static var locationErrorVC: UIAlertController {
        let alert = UIAlertController(title: "Location Service off",
                                      message: "Please enable location in settings",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let action = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl)  else { return }
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }

        alert.addAction(cancel)
        alert.addAction(action)

        return alert
    }
}
