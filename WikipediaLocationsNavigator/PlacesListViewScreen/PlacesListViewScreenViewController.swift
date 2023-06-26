//
//  PlacesListViewScreenViewController.swift
//  WikipediaLocationsNavigator
//
//  Created by Jayesh Kawli on 6/26/23.
//

import UIKit

protocol PlacesListViewable: AnyObject {
    func locationsLoaded(locations: [PlacesListViewScreenViewModel.Location])
    func displayError(with message: String, tryAgain: Bool)
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

    private var locations: [PlacesListViewScreenViewModel.Location] = []

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
        view.addSubview(tableView)
        view.addSubview(activityIndicatorView)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
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

    func displayError(with message: String, tryAgain: Bool = false) {
        activityIndicatorView.stopAnimating()
        let tryAgainAction: UIAlertAction

        if tryAgain {
            tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self] action in
                self?.activityIndicatorView.startAnimating()
                self?.viewModel.retryLastRequest()
            }
        } else {
            tryAgainAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        self.alertDisplayUtility.showAlert(with: "Error", message: message, actions: [cancelAction, tryAgainAction], parentController: self)
    }

    func locationsLoaded(locations: [PlacesListViewScreenViewModel.Location]) {
        self.locations = locations
        tableView.reloadData()
        activityIndicatorView.stopAnimating()
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
        viewModel.openDetailsForPlace(with: locations[indexPath.row].name)
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
