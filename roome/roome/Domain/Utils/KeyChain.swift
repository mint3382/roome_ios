//
//  KeyChain.swift
//  roome
//
//  Created by minsong kim on 5/20/24.
//

import Foundation

class KeyChain {
    enum keys: String {
        case appleUserID = "appleUserID"
        case isAppleLogin = "isAppleLogin"
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
    
    class func create(key: keys, data: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        
        let status = SecItemAdd(query, nil)
        
        switch status {
        case errSecSuccess:
            print("keychain success")
        case errSecDuplicateItem:
            update(key: key, data: data)
        default:
            print("keychain create failure")
        }
    }
    
    class func read(key: keys) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            let retrieveData = dataTypeRef as! Data
            let value = String(data: retrieveData, encoding: String.Encoding.utf8)
            return value
        } else {
            return nil
        }
    }
    
    class func update(key: keys, data: String) {
        let previousQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
        ]
        
        let updateQuery: NSDictionary = [
            kSecValueData: data.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        
        let status = SecItemUpdate(previousQuery, updateQuery)
        
        switch status {
        case errSecSuccess:
            print("keychain update success")
        default:
            print("keychain update failure")
        }
    }
    
    class func delete(key: keys) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(query)
        assert(status == noErr, "키체인 삭제 실패")
    }
}
