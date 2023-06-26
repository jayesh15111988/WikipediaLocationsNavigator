//
//  PlacesListViewScreenViewController.swift
//  WikipediaLocationsNavigator
//
//  Created by Jayesh Kawli on 6/26/23.
//

import UIKit

protocol PlacesListViewable: AnyObject {
    func locationsLoaded(locations: [Location])
    func displayError(with message: String)
}

class PlacesListViewScreenViewController: UIViewController, PlacesListViewable {

    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(frame: .zero)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.style = .large
        activityIndicatorView.color = .darkGray
        return activityIndicatorView
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    private var locations: [Location] = []

    private enum Constants {
        static let estimatedRowHeight: CGFloat = 44.0
    }

    private let viewModel: PlacesListViewScreenViewModel
    private let alertDisplayUtility: AlertDisplayable

    init(alertDisplayUtility: AlertDisplayable = AlertDisplayUtility(), viewModel: PlacesListViewScreenViewModel) {
        self.alertDisplayUtility = alertDisplayUtility
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        layoutViews()
        loadLocations()
    }

    private func setupViews() {
        self.title = viewModel.title
        self.view.backgroundColor = .white
    }

    private func layoutViews() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func loadLocations() {
        activityIndicatorView.startAnimating()
        viewModel.loadLocations()
    }

    func displayError(with message: String) {
        activityIndicatorView.stopAnimating()
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self] action in
            self?.viewModel.retryLastRequest()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        self.alertDisplayUtility.showAlert(with: "Error", message: message, actions: [cancelAction, tryAgainAction], parentController: self)
    }

    func locationsLoaded(locations: [Location]) {
        self.locations = locations
        tableView.reloadData()
    }
}

extension PlacesListViewScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].name
        return cell
    }
}

extension PlacesListViewScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
