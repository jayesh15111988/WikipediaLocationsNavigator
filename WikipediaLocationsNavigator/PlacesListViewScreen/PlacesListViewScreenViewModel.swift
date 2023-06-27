//
//  PlacesListViewScreenViewModel.swift
//  WikipediaLocationsNavigator
//
//  Created by Jayesh Kawli on 6/26/23.
//

import UIKit

protocol URLOpenable {
    func openURL(_ url: URL) -> Bool
}

final class PlacesListViewScreenViewModel {

    private let wikipediaPageBaseURL = "wikipedia://places?WMFArticleURL=https://en.wikipedia.org/"

    private let networkService: RequestHandling
    let title: String
    private let urlOpener: URLOpenable
    weak var view: PlacesListViewable?

    struct Location {
        let name: String
    }

    init(networkService: RequestHandling, urlOpener: URLOpenable = UIApplication.shared) {
        self.networkService = networkService
        self.urlOpener = urlOpener
        self.title = "Locations"
    }

    func loadLocations() {
        networkService.request(type: Locations.self, route: .getLocations) { [weak self] result in

            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let locations):
                    // Map from list of Decodable location objects to Location object
                    // Locations with nil names are filtered out
                    let validLocations = locations.locations.map { $0.name }.compactMap { $0 }.map { Location(name: $0) }
                    self.view?.locationsLoaded(locations: validLocations)
                case .failure(let dataLoadError):
                    self.view?.displayError(with: dataLoadError.errorMessageString(), tryAgain: true)
                }
            }
        }
    }

    func retryLastRequest() {
        self.loadLocations()
    }

    func openDetailsForPlace(with name: String) {

        // Encode any special characters in the input place name
        if let encodedName = name.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {

            let urlString = wikipediaPageBaseURL + encodedName
            let urlToOpen = URL(string: urlString)

            guard let urlToOpen else {
                view?.displayError(with: "The URL \(urlString) is invalid", tryAgain: false)
                return
            }

            let didOpenURL = urlOpener.openURL(urlToOpen)

            if !didOpenURL {
                view?.displayError(with: "The URL \(urlString) cannot be opened", tryAgain: false)
            }

        } else {
            view?.displayError(with: "The entered place \(name) has invalid characters. Please enter alphanumeric characters in search box and try again", tryAgain: false)
        }
    }
}

extension UIApplication: URLOpenable {

}
