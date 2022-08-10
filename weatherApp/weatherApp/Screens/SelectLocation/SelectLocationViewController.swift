//
//  SelectLocationViewController.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit

final class SelectLocationViewController: UIViewController, ViewProtocol {
    
    // MARK: - Typealiases
    
    typealias Presenter = SelectLocationPresenterProtocol
    
    // MARK: - Properties
    
    var presenter: Presenter?
}

// MARK: - SelectLocationViewProtocol

extension SelectLocationViewController: SelectLocationViewProtocol {}
