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
    
    let tableView = UITableView()
    private let searchBar = UISearchBar()
    private lazy var bottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    
    // MARK: - Constants {
    
    private enum Constants {
        static let placeholder = "Search.."
        static let leftImage = UIImage(named: "backIcon")
    }
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchBar()
        configureTableView()
        addObserverForKeyboard()
        
        presenter?.onViewDidLoad()
    }
    
    // MARK: - Private
    
    private func addSearchBar() {
        let searchBar = UISearchBar()
        searchBar.keyboardType = UIKeyboardType.asciiCapable
        searchBar.placeholder = Constants.placeholder
        searchBar.searchTextField.leftViewMode = .always
        searchBar.searchTextField.leftView = leftView()
        searchBar.searchBarStyle = .prominent
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func leftView() -> UIView {
        let image = Constants.leftImage
        let view = UIImageView(image: image)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(leftButtonDidTap))
        view.addGestureRecognizer(recognizer)
        view.isUserInteractionEnabled = true
        return view
    }
    
    @objc private func leftButtonDidTap() {
        presenter?.back()
    }
    
    private func configureTableView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            bottomConstraint
        ])
        
        view.layoutIfNeeded()
    }
    
    // MARK: - Keyboard
    
    private func addObserverForKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = -keyboardSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
            self.bottomConstraint.constant = .zero
            self.view.layoutIfNeeded()
    }
}

// MARK: - SearchViewProtocol

extension SearchViewController: SearchViewProtocol {}

// MARK: - UISearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
