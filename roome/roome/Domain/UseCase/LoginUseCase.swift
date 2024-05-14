//
//  LoginUseCase.swift
//  roome
//
//  Created by minsong kim on 5/15/24.
//

import Foundation

class LoginUseCase {
    private let loginRepository: LoginRepositoryType
    
    init(loginRepository: LoginRepositoryType) {
        self.loginRepository = loginRepository
    }
    
    func loginWithAPI(body json: [String: Any], decodedDataType: LoginDTO.Type) async {
        guard let tokens = await loginRepository.requestLogin(body: json, decodedDataType: decodedDataType) else {
            return
        }
        
        let query: NSDictionary = [kSecClass: kSecClassGenericPassword,
                             kSecAttrAccount: tokens.data.accessToken,
                               kSecAttrLabel: tokens.data.refreshToken]
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        print(status)
        
        if status == errSecSuccess {
            print("success")
        } else {
            print("failure")
        }
    }
    
}
