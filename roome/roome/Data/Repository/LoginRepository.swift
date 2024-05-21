//
//  LoginRepository.swift
//  roome
//
//  Created by minsong kim on 5/14/24.
//

import Foundation

class LoginRepository: LoginRepositoryType {
    func requestLogin(body json: [String: Any], decodedDataType: LoginDTO.Type) async -> LoginDTO? {
        let loginURL = URLBuilder(host: APIConstants.roomeHost, path: APIConstants.AuthPath.signIn.name, queries: nil)
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
}
