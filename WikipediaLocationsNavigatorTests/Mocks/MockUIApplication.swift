//
//  MockUIApplication.swift
//  WikipediaLocationsNavigatorTests
//
//  Created by Jayesh Kawli on 6/26/23.
//

import Foundation

@testable import WikipediaLocationsNavigator

final class MockUIApplication: URLOpenable {

    var openedURL: URL?

    func openURL(_ url: URL) -> Bool {
        openedURL = url
        return true
    }
}
