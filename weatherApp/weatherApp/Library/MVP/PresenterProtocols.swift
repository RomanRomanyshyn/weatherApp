//
//  PresenterProtocols.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import Foundation

protocol PresenterProtocol: AnyObject {

    associatedtype View
    associatedtype Coordinator
    associatedtype Parameters

    var view: View? { get set }
    var coordinator: Coordinator? { get set }

    init(parameters: Parameters, view: View, coordinator: Coordinator)
}

// MARK: - Base presenter

protocol BasePresenterProtocol: AnyObject {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
}

extension BasePresenterProtocol {
    func onViewDidLoad() {}
    func onViewWillAppear() {}
    func onViewDidAppear() {}
}
