//
//  URLProtocolMock.swift
//  WikipediaLocationsNavigatorTests
//
//  Created by Jayesh Kawli on 6/27/23.
//

import Foundation

// Referenced from: https://forums.raywenderlich.com/t/chapter-8-init-deprecated-in-ios-13/102050/6
final class URLProtocolMock: URLProtocol {
    static var mockURLs = [URL?: (error: Error?, data: Data?, response: HTTPURLResponse?)]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url {
            if let (error, data, response) = URLProtocolMock.mockURLs[url] {

                if let responseStrong = response {
                    self.client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
                }

                if let dataStrong = data {
                    self.client?.urlProtocol(self, didLoad: dataStrong)
                }

                if let errorStrong = error {
                    self.client?.urlProtocol(self, didFailWithError: errorStrong)
                }
            }
        }

        DispatchQueue.main.async {
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {
        // no-op
    }
}




