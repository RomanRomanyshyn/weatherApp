//
//  SearchViewController.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit

final class SearchViewController: UIViewController, ViewProtocol {
    
    // MARK: - Typealiases
    
    typealias Presenter = SearchPresenterProtocol
    
    // MARK: - Properties
    
    var presenter: Presenter?
    
}

// MARK: - SearchViewProtocol

extension SearchViewController: SearchViewProtocol {}
