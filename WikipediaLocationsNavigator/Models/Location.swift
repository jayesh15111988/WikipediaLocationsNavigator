//
//  Location.swift
//  WikipediaLocationsNavigator
//
//  Created by Jayesh Kawli on 6/26/23.
//

import MapKit

struct Location: Decodable {
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}
