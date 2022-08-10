//
//  SelectLocationPresenter.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import Foundation

final class SelectLocationPresenter: PresenterProtocol {
    
    // MARK: - Typealiases
    
    typealias View = SelectLocationViewProtocol
    typealias Coordinator = SelectLocationCoordinatorProtocol
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

// MARK: - SelectLocationPresenterProtocol

extension SelectLocationPresenter: SelectLocationPresenterProtocol {}
