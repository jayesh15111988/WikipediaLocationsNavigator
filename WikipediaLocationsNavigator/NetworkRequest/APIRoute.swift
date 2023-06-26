//
//  APIRoute.swift
//  WikipediaLocationsNavigator
//
//  Created by Jayesh Kawli on 6/26/23.
//

import Foundation

/// An enum to encode all the operations associated with specific endpoint
enum APIRoute {
    case getLocations

    // Base URL on which all the URL requests are based
    private var baseURLString: String { "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/" }

    private var url: URL? {
        switch self {
        case .getLocations:
            return URL(string: baseURLString + "main/locations.json")
        }
    }

    private var parameters: [URLQueryItem] {
        return []
    }

    /// A method to convert given APIRoute case into URLRequest object
    /// - Returns: An instance of URLRequest
    func asRequest() -> URLRequest {
        guard let url = url else {
            preconditionFailure("Missing URL for route: \(self)")
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if !parameters.isEmpty {
            components?.queryItems = parameters
        }

        guard let parametrizedURL = components?.url else {
            preconditionFailure("Missing URL with parameters for url: \(url)")
        }

        return URLRequest(url: parametrizedURL)
    }
}


