//
//  Config.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import Foundation

protocol IConfig {
    func baseUrl() -> String
}

enum ConfigError: Error {
    case missingKey
    case invalidValue
}

final class Config {
    static let shared = Config()
    
    // MARK: - Private
    
    private enum ConfigKeys: String {
        case baseUrl = "API_BASE_URL"
    }
    
    private let baseUrlValue: String
    
    private init() {
        do {
            let baseUrl: String = try Config.value(for: ConfigKeys.baseUrl.rawValue)
            self.baseUrlValue = "https://" + baseUrl
        } catch {
            #if DEBUG
            fatalError("Exception \(#file) \(#function) \(#line) \(error)")
            #else
            debugPrint("Exception \(#file) \(#function) \(#line) \(error)")
            self.baseUrlValue = ""
            #endif
        }
    }
    
    private static func value<T>(for key: String) throws -> T {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw ConfigError.missingKey
        }

        if let value = object as? T {
            return value
        } else {
            throw ConfigError.invalidValue
        }
    }
}

extension Config: IConfig {
    
    func baseUrl() -> String {
        return self.baseUrlValue
    }
}
