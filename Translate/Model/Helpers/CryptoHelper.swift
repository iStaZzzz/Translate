//
//  CryptoHelper.swift
//  Translate
//
//  Created by Stanislav Ivanov on 29.03.2020.
//  Copyright © 2020 Stanislav Ivanov. All rights reserved.
//

import Foundation

import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

final class CryptoHelper {

    func dataMD5(string: String) -> Data? {
        guard let messageData = string.data(using:.utf8) else {
            return nil
        }
        
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes { (digestBytes) -> Bool in
            messageData.withUnsafeBytes({ (messageBytes) -> Bool in
                _ = CC_MD5(messageBytes.baseAddress, CC_LONG(messageData.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
                return true
            })
        }
        
        return digestData
    }
    
    func stringMD5(string: String) -> String? {
        guard let md5Data = self.dataMD5(string: string) else {
            return nil
        }
        let md5Base64 = md5Data.base64EncodedString()
        return md5Base64
    }
}
