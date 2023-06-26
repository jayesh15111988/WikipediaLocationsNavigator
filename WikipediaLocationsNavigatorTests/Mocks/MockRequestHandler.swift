//
//  MockRequestHandler.swift
//  WikipediaLocationsNavigatorTests
//
//  Created by Jayesh Kawli on 6/26/23.
//

import Foundation

@testable import WikipediaLocationsNavigator

final class MockRequestHandler: RequestHandling {

    var toFail = false

    func request<T>(type: T.Type, route: APIRoute, completion: @escaping (Result<T, DataLoadError>) -> Void) where T : Decodable {

        if toFail {
            completion(.failure(DataLoadError.genericError("Something went wrong while loading a request")))
            return
        }

        switch route {
        case .getLocations:
            let artObjectsList: T? = JSONDataReader.getModelFromJSONFile(with: "locations")
            completion(.success(artObjectsList!))
        }
    }
}


