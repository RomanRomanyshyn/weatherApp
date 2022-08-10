//
//  HomeViewController.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit

final class HomeViewController: UIViewController, ViewProtocol {
    
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var tableHeight: NSLayoutConstraint!
    // MARK: - Typealiases
    
    typealias Presenter = HomePresenterProtocol
    
    // MARK: - Properties
    
    var presenter: Presenter?
    
    private var contentSizeObserver: NSKeyValueObservation?
    private let actionSheet = UIAlertController()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDynamicHeightForTableView()
        configureActionSheet()
        configureNavButton()
        presenter?.onViewDidLoad()
    }
    
    // MARK: - Private
    
    private func setDynamicHeightForTableView() {
        contentSizeObserver = observe(\.tableView.contentSize, options: .new) {[weak self] _, change in
            guard let value = change.newValue else { return }
            self?.tableHeight.constant = value.height
            self?.view.layoutIfNeeded()
        }
    }
    
    private func configureActionSheet() {
        
        let mapAction = UIAlertAction(title: "Map", style: .default) { [weak self] _ in
            self?.presenter?.map()
        }
        
        let searchListAction = UIAlertAction(title: "search list", style: .default) { [weak self] _ in
            self?.presenter?.searchList()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(mapAction)
        actionSheet.addAction(searchListAction)
        actionSheet.addAction(cancelAction)
    }
    
    private func configureNavButton() {
        let item = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonDidTap))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc private func searchButtonDidTap() {
        present(actionSheet, animated: true)
    }
}

// MARK: - HomeViewProtocol

extension HomeViewController: HomeViewProtocol {
    func set(title: String) {
        self.title = title
    }
    
    func setMainInfo(temp: String, humidity: String, wind: String) {
        temperatureLabel.text = temp
        humidityLabel.text = humidity
        windLabel.text = wind
    }
    
    func setMainImage(_ image: UIImage?) {
        mainImageView.image = image
    }
}
