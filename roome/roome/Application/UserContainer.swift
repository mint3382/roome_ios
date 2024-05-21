//
//  UserContainer.swift
//  roome
//
//  Created by minsong kim on 5/20/24.
//

import Foundation

class UserContainer {
    static let shared = UserContainer()
    var user: UserDTO?
    
    private init() {}
    
    func updateUserInformation() async throws {
        let userURL = URLBuilder(host: APIConstants.roomeHost,
                                 path: APIConstants.UserPath.users.name,
                                 queries: nil)
        guard let url = userURL.url else {
            throw TypeError.bindingFailure
        }
        
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        let requestBuilder = RequestBuilder(url: url, method: .get, headers: header)
        guard let request = requestBuilder.create() else {
            throw TypeError.bindingFailure
        }
        
        user = try await APIProvider().fetchDecodedData(type: UserDTO.self, from: request)
    }
}
