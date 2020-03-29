//
//  NetworkRequest.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import Foundation

enum NetworkRequestType {
    case task
}

enum NetworkRequestMethod: String {
    case get = "GET"
}

final class NetworkRequest {
    
    /// Dependency
    private let config = Config.shared
    
    // MARK: Params
    var baseURL: String { return self.config.baseUrl() }
    var type:    NetworkRequestType = .task
    var path:    String?
    var method:  NetworkRequestMethod = .get
    var body:    Data?
    
    var timeoutInterval: TimeInterval = 15
    var httpHeaderFields: [String : String] = [:]
    
    func url() -> URL? {
        var urlString = self.baseURL
        
        if let path = self.path, let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            urlString.append(encodedPath)
        }
        return URL(string: urlString)
    }
    
    func request() -> URLRequest? {
        guard let url = self.url() else {
            return nil
        }
        
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: self.timeoutInterval)
        request.httpMethod = self.method.rawValue
        
        if let body = self.body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        for key in self.httpHeaderFields.keys {
            let value = self.httpHeaderFields[key]
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
