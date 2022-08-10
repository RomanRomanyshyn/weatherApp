//
//  HomeViewController.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit
import SkeletonView

final class HomeViewController: UIViewController, ViewProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    
    @IBOutlet private weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Typealiases
    
    typealias Presenter = HomePresenterProtocol
    
    // MARK: - Properties
    
    var presenter: Presenter?
    
    private var contentSizeObserver: NSKeyValueObservation?
    private let actionSheet = UIAlertController()
    
    private var skeletonables: [UIView] { [
        mainImageView,
        temperatureLabel,
        humidityLabel,
        windLabel
    ] }
    
    // MARK: - Constants
    
    private enum Constants {
        static let skeletonColor = UIColor(named: "secondaryBlue") ?? .blue
        
        enum ActionSheet {
            static let map = "Map"
            static let searchList = "Search list"
            static let cancel = "Cancel"
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDynamicHeightForTableView()
        configureNaviagationButton()
        configureActionSheet()
        showSkeletons()
        
        presenter?.onViewDidLoad()
    }
    
    // MARK: - Private
    
    private func showSkeletons() {
        skeletonables.forEach { view in
            view.isSkeletonable = true
            view.showAnimatedGradientSkeleton()
            view.updateSkeleton(usingColor: Constants.skeletonColor)
        }
    }
    
    private func setDynamicHeightForTableView() {
        contentSizeObserver = observe(\.tableView.contentSize, options: .new) {[weak self] _, change in
            guard let self = self,
                  let value = change.newValue else { return }
            self.tableHeight.constant = value.height
            self.tableView.isScrollEnabled = false
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureActionSheet() {
        let mapAction = UIAlertAction(title: Constants.ActionSheet.map,
                                      style: .default) { [weak self] _ in
            self?.presenter?.map()
        }
        
        let searchListAction = UIAlertAction(title: Constants.ActionSheet.searchList,
                                             style: .default) { [weak self] _ in
            self?.presenter?.searchList()
        }
        
        let cancelAction = UIAlertAction(title: Constants.ActionSheet.cancel,
                                         style: .cancel)
        
        actionSheet.addAction(mapAction)
        actionSheet.addAction(searchListAction)
        actionSheet.addAction(cancelAction)
    }
    
    private func configureNaviagationButton() {
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
        temperatureLabel.hideSkeleton()

        humidityLabel.text = humidity
        humidityLabel.hideSkeleton()

        windLabel.text = wind
        windLabel.hideSkeleton()
    }
    
    func setMainImage(_ image: UIImage?) {
        mainImageView.image = image
        mainImageView.hideSkeleton()
    }
}
