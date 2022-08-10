//
//  SearchPresenter.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import Foundation

final class SearchPresenter: PresenterProtocol {
    
    // MARK: - Typealiases
    
    typealias View = SearchViewProtocol
    typealias Coordinator = SearchCoordinatorProtocol
    typealias Parameters = Void
    
    // MARK: - Properties
    
    weak var view: View?
    weak var coordinator: Coordinator?
    
    // MARK: - Init
    
    init(parameters: Void, view: View, coordinator: Coordinator) {
        self.view = view
        self.coordinator = coordinator
    }
}

// MARK: - SearchPresenterProtocol

extension SearchPresenter: SearchPresenterProtocol {}
