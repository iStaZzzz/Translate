//
//  SearchRequestTests.swift
//  TranslateTests
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import XCTest

final class SearchRequestTests: BaseTests {
    
    let networkDataSource = NetworkDataSource.shared
    
    func testSearchRequest() {
        
        let request = NetworkRequest.makeWordSearch(query: "1")
        let result = RequestResult<[Word]>()
        
        // Make mock
        let requestUrl = request.request()!.url!.absoluteString
        let url = URL(string: requestUrl)!
        let resultData = self.loadDataFrom(fileName: "RealSearchResponse.json")!
        URLProtocolMock.testURLs = [url: resultData]
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        NetworkDataSource.prepeare(with: session)
        
        // Execute
        let expectation = XCTestExpectation(description: "testSearchRequest")
        self.networkDataSource.execute(networkRequet: request, result: result) {
            XCTAssertEqual(result.result?.isEmpty, false)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
