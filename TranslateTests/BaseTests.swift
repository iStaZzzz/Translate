//
//  BaseTests.swift
//  TranslateTests
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import XCTest

final class URLProtocolMock: URLProtocol {
    // this dictionary maps URLs to test data
    static var testURLs = [URL?: Data]()

    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    // ignore this method; just send back what we were given
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        // if we have a valid URL…
        if let url = request.url {
            // …and if we have test data for that URL…
            if let data = URLProtocolMock.testURLs[url] {
                // …load it immediately.
                self.client?.urlProtocol(self, didLoad: data)
            }
        }

        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    // this method is required but doesn't need to do anything
    override func stopLoading() { }
}

class BaseTests: XCTestCase {

    func loadDataFrom(fileName: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: fileName, withExtension: nil)!
        let data = try! Data.init(contentsOf: fileUrl)
        return data
    }
}
