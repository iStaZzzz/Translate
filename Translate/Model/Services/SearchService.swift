//
//  SearchService.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import Foundation

typealias SearchCompletion = (_ word: String, _ translations: [Word], _ error: Error?) -> Void

protocol ISearchService {
    func search(word: String, completion: @escaping SearchCompletion)
}

// MARK: - SearchService
final class SearchService {
    static let shared = SearchService()
    
    // MARK: Private
    
    private init() { }
    private lazy var networkDataSource: INetworkDataSource = NetworkDataSource.shared
}

// MARK: - ISearchService
extension SearchService: ISearchService {
    func search(word: String, completion: @escaping SearchCompletion) {
        let request = NetworkRequest.makeWordSearch(query: word)
        let result = RequestResult<[Word]>()
        self.networkDataSource.execute(networkRequet: request, result: result) {
            completion(word, result.result ?? [], result.error)
        }
    }
}
