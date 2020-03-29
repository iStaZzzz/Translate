//
//  Word.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import Foundation

struct Word: Decodable, Equatable {
    let id: Int
    let text: String
    let meanings: [Meaning]
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case meanings
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id       = try container.decode(Int.self,      forKey: .id)
        self.text     = try container.decode(String.self,   forKey: .text)
        self.meanings = try container.decode([Meaning].self, forKey: .meanings)
    }
}
