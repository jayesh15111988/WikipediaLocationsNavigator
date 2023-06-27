//
//  PlacesListViewScreenViewModelTests.swift
//  WikipediaLocationsNavigatorTests
//
//  Created by Jayesh Kawli on 6/26/23.
//

import XCTest

@testable import WikipediaLocationsNavigator

final class PlacesListViewScreenViewModelTests: XCTestCase {

    func testThatViewModelOpensUniversalLinkForGivenPlace() {
        let networkService = MockRequestHandler()
        let application = MockUIApplication()
        let viewModel = PlacesListViewScreenViewModel(networkService: networkService, urlOpener: application)

        viewModel.openDetailsForPlace(with: "Boston")
        XCTAssertEqual(application.openedURL?.absoluteString, "wikipedia://places?WMFArticleURL=https://en.wikipedia.org/Boston")
    }

    func testThatViewModelCorrectlySetsTheErrorState() {
        let networkService = MockRequestHandler()
        networkService.toFail = true
        let viewModel = PlacesListViewScreenViewModel(networkService: networkService)
        let view = MockPlacesListViewScreenViewController()
        viewModel.view = view

        viewModel.loadLocations()

        let expectation = XCTestExpectation(description: "View model will set error state after failed download")

        DispatchQueue.main.async {
            XCTAssertEqual(view.shownErrorMessage, "Something went wrong while loading a request")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testThatViewModelCorrectlySetsTheSuccessState() {
        let networkService = MockRequestHandler()
        let viewModel = PlacesListViewScreenViewModel(networkService: networkService)
        let view = MockPlacesListViewScreenViewController()
        viewModel.view = view

        viewModel.loadLocations()

        let expectation = XCTestExpectation(description: "View model will set locations after successful download")

        DispatchQueue.main.async {
            XCTAssertEqual(view.loadedLocations.count, 3)

            if let firstLocation = view.loadedLocations.first {
                XCTAssertEqual(firstLocation.name, "Amsterdam")
            } else {
                XCTFail("Failed to get the valid location from loaded locations list. Expected at least one valid location")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testThatAppCanRetryThePreviouslyFailedNetworkRequest() {
        let networkService = MockRequestHandler()
        networkService.toFail = true
        let viewModel = PlacesListViewScreenViewModel(networkService: networkService)
        let view = MockPlacesListViewScreenViewController()
        viewModel.view = view

        viewModel.loadLocations()

        let expectation = XCTestExpectation(description: "View model will successfully retry the network operation after failed request")

        DispatchQueue.main.async {
            XCTAssertEqual(view.shownErrorMessage, "Something went wrong while loading a request")

            networkService.toFail = false

            viewModel.loadLocations()

            DispatchQueue.main.async {
                XCTAssertEqual(view.loadedLocations.count, 3)

                if let firstLocation = view.loadedLocations.first {
                    XCTAssertEqual(firstLocation.name, "Amsterdam")
                } else {
                    XCTFail("Failed to get the valid location from loaded locations list. Expected at least one valid location")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testThatViewModelTitleIsCorrect() {
        let networkService = MockRequestHandler()
        let viewModel = PlacesListViewScreenViewModel(networkService: networkService)

        XCTAssertEqual(viewModel.title, "Locations")
    }
}
