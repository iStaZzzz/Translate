//
//  NetworkDataSource.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import Foundation

final class RequestResult<T: Decodable>{
    var result: T?
    var error: Error?
    var responseData: Data?
}

protocol INetworkDataSource {
    func execute<T: Decodable>(networkRequet: NetworkRequest, result: RequestResult<T>, completion: @escaping () -> ())
}

// MARK: - NetworkDataSource
final class NetworkDataSource {
    static let shared = NetworkDataSource()
    
    static func prepeare(with urlSession: URLSession) {
        NetworkDataSource.shared.urlSession = urlSession
    }
    
    // MARK: Private
    
    private init() {
        let config = URLSessionConfiguration.default
        config.httpMaximumConnectionsPerHost = 10
        config.timeoutIntervalForRequest = 10
        self.urlSession = URLSession(configuration: config)
    }

    private var urlSession: URLSession
}

// MARK: - INetworkDataSource
extension NetworkDataSource: INetworkDataSource {
    
    func execute<T: Decodable>(networkRequet: NetworkRequest, result: RequestResult<T>, completion: @escaping () -> ()) {

        guard let request = networkRequet.request() else {
            completion()
            return
        }
        
#if DEBUG
        let start = Date()
#endif
        let taskCompletion = { (data: Data?, response: URLResponse?, error: Error?) in
#if DEBUG
            debugPrint("API CALL")
            debugPrint("  request:")
            debugPrint("  url = \(String(describing: request.url))")
            debugPrint("  method = \(String(describing: request.httpMethod))")
            if let requestData = request.httpBody {
                debugPrint("  Body:")
                debugPrint("    body size = \(requestData.count)")
                debugPrint("    body string = \(String(describing: String(data: requestData, encoding: .utf8)))")
            }
            if let headers = request.allHTTPHeaderFields {
                debugPrint("  Headers:")
                for header in headers {
                    debugPrint("    \(header.key) = \(header.value)")
                }
            }

            debugPrint("  response:")
            debugPrint("  statusCode = \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            
            
            if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                if responseString.count < 3000 {
                    debugPrint("  data = \(responseString)")
                } else {
                    debugPrint("  big data")
                }
            } else {
                debugPrint("  no data")
            }
            
            debugPrint("  request time \(Date().timeIntervalSince(start))")
#endif
            result.responseData = data
            result.error = error
            if let data = data {
                do {
                    result.result = try JSONDecoder().decode(T.self, from: data)
                } catch {
                    result.error = error
                }
            }
            
            completion()
        }
        
        let task = self.urlSession.dataTask(with: request, completionHandler: taskCompletion)
        task.resume()
    }
}
