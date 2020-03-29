//
//  SearchResultCellPresenter.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import Foundation

final class SearchResultCellPresenter: ISearchResultCellPresenter, Equatable {
    
    let word: Word
    let meaning: Meaning?

    var isWordExpanded: Bool = false
    
    init(word: Word) {
        self.word = word
        self.meaning = nil
    }
    
    init(word: Word, meaning: Meaning) {
        self.word = word
        self.meaning = meaning
    }
    
    // MARK: ISearchResultCellPresenter
    
    func text() -> String {
        if let meaning = self.meaning {
            return meaning.translation.text
        }
        
        return word.text
    }
    
    func isMeaning() -> Bool {
        return self.meaning != nil
    }
    
    func isExpanded() -> Bool {
        return self.isWordExpanded
    }
    
    // MARK: Equatable
    
    static func == (lhs: SearchResultCellPresenter, rhs: SearchResultCellPresenter) -> Bool {
        return lhs.meaning == rhs.meaning && lhs.word == rhs.word
    }
}
