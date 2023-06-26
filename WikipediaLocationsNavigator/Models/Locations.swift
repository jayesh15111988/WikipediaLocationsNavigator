//
//  Locations.swift
//  WikipediaLocationsNavigator
//
//  Created by Jayesh Kawli on 6/26/23.
//

import MapKit

typealias Location = Locations.Location

struct Locations: Decodable {
    let locations: [Location]

    struct Location: Decodable {
        let name: String?
        let lat: CLLocationDegrees
        let long: CLLocationDegrees
    }
}
