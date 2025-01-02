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
    func isTokenValid(token: String) -> Bool
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
    
    func isTokenValid(token: String) -> Bool {
        guard let payload = decodeJWT(token),
              let exp = payload["exp"] as? TimeInterval else {
            print("Failed to decode token or missing 'exp' field.")
            return false
        }
        
        let expirationDate = Date(timeIntervalSince1970: exp)
        return expirationDate > Date()
    }
    
    func decodeJWT(_ jwt: String) -> [String: Any]? {
        let segments = jwt.split(separator: ".")
        guard segments.count == 3 else {
            print("Invalid JWT format.")
            return nil
        }
        
        let payloadSegment = String(segments[1])
        
        var base64 = payloadSegment.replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 {
            base64.append("=")
        }
        
        guard let data = Data(base64Encoded: base64) else {
            print("Invalid Base64URL payload.")
            return nil
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonObject as? [String: Any]
        } catch {
            print("Failed to parse JWT payload: \(error.localizedDescription)")
            return nil
        }
    }
}
