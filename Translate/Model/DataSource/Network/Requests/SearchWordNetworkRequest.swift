//
//  SearchWordNetworkRequest.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import Foundation

extension NetworkRequest {
    static func makeWordSearch(query: String, page: Int = 1, pageSize: Int = 5) -> NetworkRequest {
        let networkRequest  = NetworkRequest()
        networkRequest.path = NetworkPath.search.rawValue + "?search=\(query)&page=\(page)&pageSize=\(pageSize)"
        return networkRequest
    }
}
