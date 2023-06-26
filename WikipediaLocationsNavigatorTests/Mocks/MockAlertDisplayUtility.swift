//
//  MockAlertDisplayUtility.swift
//  WikipediaLocationsNavigatorTests
//
//  Created by Jayesh Kawli on 6/26/23.
//

import UIKit

@testable import WikipediaLocationsNavigator

final class MockAlertDisplayUtility: AlertDisplayable {

    var shownTitle = ""
    var shownMessage = ""

    func showAlert(with title: String, message: String, actions: [UIAlertAction], parentController: UIViewController) {
        self.shownTitle = title
        self.shownMessage = message
    }
}
