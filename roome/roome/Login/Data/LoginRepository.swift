//
//  LoginRepository.swift
//  roome
//
//  Created by minsong kim on 5/14/24.
//

import Foundation

class LoginRepository: LoginRepositoryType {
    func requestLogin(body json: [String: Any], decodedDataType: LoginDTO.Type) async -> LoginDTO? {
        let loginURL = URLBuilder(host: APIConstants.roomeHost, path: APIConstants.Auth.signIn.name, queries: nil)
        guard let url = loginURL.url else {
            return nil
        }
        
        let requestBuilder = RequestBuilder(url: url, method: .post, bodyJSON: json)
        guard let request = requestBuilder.create() else {
            return nil
        }

        do {
            let token = try await APIProvider().fetchDecodedData(type: decodedDataType.self, from: request)
            print("login success")
            print(token)
            return token
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func requestLogOut() async throws {
        let logoutURL = URLBuilder(host: APIConstants.roomeHost, path: APIConstants.Auth.signOut.name, queries: nil)
        guard let url = logoutURL.url else {
            throw TypeError.bindingFailure
        }
        
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        
        let requestBuilder = RequestBuilder(url: url,
                                            method: .post,
                                            headers: header)
        guard let request = requestBuilder.create() else {
            throw TypeError.bindingFailure
        }
        
        _ = try await APIProvider().fetchData(from: request)
    }
    
    func requestSignOut(body json: [String: Any?]) async throws {
        let withdrawalURL = URLBuilder(host: APIConstants.roomeHost, path: APIConstants.Auth.withdrawal.name, queries: nil)
        guard let url = withdrawalURL.url else {
            throw TypeError.bindingFailure
        }
        
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        
        let requestBuilder = RequestBuilder(url: url,
                                            method: .post,
                                            bodyJSON: json,
                                            headers: header)
        guard let request = requestBuilder.create() else {
            throw TypeError.bindingFailure
        }
        
        _ = try await APIProvider().fetchData(from: request)
    }
}
