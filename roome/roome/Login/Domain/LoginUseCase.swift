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
    
    func loginWithAPI(body json: [String: Any], decodedDataType: LoginDTO.Type) async throws {
        guard let tokens = await loginRepository.requestLogin(body: json, decodedDataType: decodedDataType) else {
            throw TypeError.bindingFailure
        }
        
        KeyChain.create(key: .accessToken, data: tokens.data.accessToken)
        KeyChain.create(key: .refreshToken, data: tokens.data.refreshToken)
        KeyChain.create(key: .hasToken, data: "true")
        
        try await UserContainer.shared.updateUserInformation()
    }
    
    func signOutWithAPI(body json: [String: Any?]) async throws {
        try await loginRepository.requestSignOut(body: json)
    }
}
