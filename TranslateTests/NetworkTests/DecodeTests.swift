//
//  DecodeTests.swift
//  TranslateTests
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import XCTest

final class DecodeTests: BaseTests {

    func testNormalDecode() {
        guard let data = self.loadDataFrom(fileName: "RealSearchResponse.json") else {
            XCTFail("Can not load data from local file")
            return
        }
        
        do {
            _ = try JSONDecoder().decode([Word].self, from: data)
        } catch {
            XCTFail("catch error \(error)")
        }
    }
    
    func testEmptyDecode() {
        let string = "[]"
        let data = string.data(using: .utf8)!
        
        do {
            let words = try JSONDecoder().decode([Word].self, from: data)
            XCTAssertEqual(words.count, 0)
        } catch {
            XCTFail("catch error \(error)")
        }
    }
    
    func testMissingIdDecode() {
        let string = """
[
  {
    "text": "tree",
    "meanings": [
      {
        "id": 117716,
        "partOfSpeechCode": "n",
        "translation": {
          "text": "дерево",
          "note": null
        },
        "previewUrl": "",
        "imageUrl": "",
        "transcription": "triː",
        "soundUrl": ""
      }
    ]
  }
]
"""
        let data = string.data(using: .utf8)!
        do {
            _ = try JSONDecoder().decode([Word].self, from: data)
            XCTFail("word without id parsed")
        } catch {
            XCTAssert(true)
        }
    }
    
    func testMissingTextDecode() {
        let string = """
[
  {
    "id": 534,
    "meanings": [
      {
        "id": 117716,
        "partOfSpeechCode": "n",
        "translation": {
          "text": "дерево",
          "note": null
        },
        "previewUrl": "",
        "imageUrl": "",
        "transcription": "triː",
        "soundUrl": ""
      }
    ]
  }
]
"""
        let data = string.data(using: .utf8)!
        do {
            _ = try JSONDecoder().decode([Word].self, from: data)
            XCTFail("word without text parsed")
        } catch {
            XCTAssert(true)
        }
    }
    
    func testMissingMeaningsDecode() {
        let string = """
[
  {
    "id": 534,
    "text": "tree"
  }
]
"""
        let data = string.data(using: .utf8)!
        do {
            _ = try JSONDecoder().decode([Word].self, from: data)
            XCTFail("word without meanings parsed")
        } catch {
            XCTAssert(true)
        }
    }
}
