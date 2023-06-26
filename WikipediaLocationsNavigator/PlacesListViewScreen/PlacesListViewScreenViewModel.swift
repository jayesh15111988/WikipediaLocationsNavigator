//
//  PlacesListViewScreenViewModel.swift
//  WikipediaLocationsNavigator
//
//  Created by Jayesh Kawli on 6/26/23.
//

import UIKit

protocol URLOpenable {
    func canOpenURL(_ url: URL) -> Bool
    func openURL(_ url: URL) -> Bool
}

final class PlacesListViewScreenViewModel {

    private let wikipediaPageBaseURL = "wikipedia://places?WMFArticleURL=https://en.wikipedia.org/"

    private let networkService: RequestHandling
    let title: String
    private let urlOpener: URLOpenable
    weak var view: PlacesListViewable?

    init(networkService: RequestHandling, urlOpener: URLOpenable = UIApplication.shared) {
        self.networkService = networkService
        self.urlOpener = urlOpener
        self.title = "Locations"
    }

    func loadLocations() {
        networkService.request(type: Locations.self, route: .getLocations) { [weak self] result in

            guard let self else { return }

            switch result {
            case .success(let locations):
                self.view?.locationsLoaded(locations: locations.locations)
            case .failure(let dataLoadError):
                self.view?.displayError(with: dataLoadError.errorMessageString())
            }
        }
    }

    func retryLastRequest() {
        self.loadLocations()
    }

    func openDetailsForPlace(with name: String) {

        let urlString = wikipediaPageBaseURL + name
        let urlToOpen = URL(string: urlString)

        guard let urlToOpen else {
            view?.displayError(with: "The URL string \(urlString) is invalid")
            return
        }
        if urlOpener.canOpenURL(urlToOpen) {
            _ = urlOpener.openURL(urlToOpen)
        } else {
            view?.displayError(with: "Cannot open the URL \(urlString) in the Wikipedia app")
        }
    }
}

extension UIApplication: URLOpenable {

}
