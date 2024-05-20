//
//  KeyChain.swift
//  roome
//
//  Created by minsong kim on 5/20/24.
//

import Foundation

class KeyChain {
    enum keys: String {
        case userID = "userID"
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
    
    class func create(key: keys, data: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "키체인 저장 실패")
    }
    
    class func read(key: keys) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
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
    
    class func delete(key: keys) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query)
        assert(status == noErr, "키체인 삭제 실패")
    }
}
