//
//  Meaning.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import Foundation

struct Meaning: Decodable, Equatable {
    
    let id: Int
    let translation: Translation
    let previewUrl: String?
    let soundUrl: String?
    
    static func == (lhs: Meaning, rhs: Meaning) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case translation
        case previewUrl
        case soundUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id          = try  container.decode(Int.self,         forKey: .id)
        self.translation = try  container.decode(Translation.self, forKey: .translation)
        self.previewUrl  = try? container.decode(String.self,      forKey: .previewUrl)
        self.soundUrl    = try? container.decode(String.self,      forKey: .soundUrl)
    }
}
