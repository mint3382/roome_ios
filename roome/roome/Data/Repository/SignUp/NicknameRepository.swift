//
//  NicknameRepository.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import Foundation

class NicknameRepository: NicknameRepositoryType {
    func requestNickname(_ name: String) async throws {
        
        let nicknameURL = URLBuilder(host: APIConstants.roomeHost,
                                     path: APIConstants.UserPath.nickname.name,
                                     queries: nil)
        guard let url = nicknameURL.url else {
            throw TypeError.bindingFailure
        }
        
        
        let body: [String: Any] = ["nickname": name]
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        
        let requestBuilder = RequestBuilder(url: url, 
                                            method: .put,
                                            bodyJSON: body,
                                            headers: header)
        guard let request = requestBuilder.create() else {
            throw  TypeError.bindingFailure
        }
        
        _ = try await APIProvider().fetchData(from: request)
    }
}
