//
//  ViewProtocol.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import Foundation

// MARK: - ViewProtocol

protocol ViewProtocol: AnyObject {
    associatedtype Presenter
    var presenter: Presenter? { get set }
}
