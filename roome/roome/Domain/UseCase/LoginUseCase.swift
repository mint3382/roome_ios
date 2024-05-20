//
//  LoginUseCase.swift
//  roome
//
//  Created by minsong kim on 5/15/24.
//

import Foundation

class LoginUseCase {
    private let loginRepository: LoginRepositoryType
    private let userRepository: UserRepositoryType
    
    init(loginRepository: LoginRepositoryType, userRepository: UserRepositoryType) {
        self.loginRepository = loginRepository
        self.userRepository = userRepository
    }
    
    func loginWithAPI(body json: [String: Any], decodedDataType: LoginDTO.Type) async -> String? {
        guard let tokens = await loginRepository.requestLogin(body: json, decodedDataType: decodedDataType) else {
            return nil
        }
        
        KeyChain.create(key: .accessToken, data: tokens.data.accessToken)
        KeyChain.create(key: .refreshToken, data: tokens.data.refreshToken)
        
        let user = await userRepository.userWithAPI(decodedDataType: UserDTO.self)
        
        return user?.data.state
    }
    
//    func callUserInformation() {
//        
//    }
//    
}
