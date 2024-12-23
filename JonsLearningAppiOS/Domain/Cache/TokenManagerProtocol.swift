//
//  TokenManagerProtocol.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/22/24.
//

import Security
import SwiftUI

protocol TokenManagerProtocol {
    func storeToken(_ token: String, forKey key: String) -> Bool
    func retrieveToken(forKey key: String) -> String?
    func deleteToken(forKey key: String) -> Bool
}

class TokenManager: TokenManagerProtocol {
    func storeToken(_ token: String, forKey key: String) -> Bool {
        let tokenData = Data(token.utf8)
        
        // Remove any existing item for this key
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
        
        // Add the new token
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: tokenData
        ]
        return SecItemAdd(addQuery as CFDictionary, nil) == errSecSuccess
    }
    
    func retrieveToken(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let tokenData = result as? Data {
            return String(data: tokenData, encoding: .utf8)
        }
        
        return nil
    }
    
    func deleteToken(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
