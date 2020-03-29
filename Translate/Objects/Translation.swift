//
//  Translation.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import Foundation

struct Translation: Decodable {
    let text: String
    let note: String?
    
    enum CodingKeys: String, CodingKey {
        case text
        case note
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.text = try  container.decode(String.self, forKey: .text)
        self.note = try? container.decode(String.self, forKey: .note)
    }
}
