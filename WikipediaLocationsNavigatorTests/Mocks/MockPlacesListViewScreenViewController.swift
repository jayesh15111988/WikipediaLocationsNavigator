//
//  MockPlacesListViewScreenViewController.swift
//  WikipediaLocationsNavigatorTests
//
//  Created by Jayesh Kawli on 6/26/23.
//

import Foundation

@testable import WikipediaLocationsNavigator

final class MockPlacesListViewScreenViewController: PlacesListViewable {

    var shownErrorMessage = ""
    var loadedLocations: [PlacesListViewScreenViewModel.Location] = []

    func locationsLoaded(locations: [PlacesListViewScreenViewModel.Location]) {
        loadedLocations = locations
    }

    func displayError(with message: String, tryAgain: Bool) {
        shownErrorMessage = message
    }
}
