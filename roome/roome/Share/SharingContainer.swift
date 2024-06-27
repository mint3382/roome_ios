//
//  SharingContainer.swift
//  roome
//
//  Created by minsong kim on 6/26/24.
//

import UIKit

class SharingContainer {
    private let apiProvider = APIProvider()
    let nickname: String
    var profile: ProfileDTO?
    
    init(nickname: String) {
        self.nickname = nickname
    }
    
    func updateSharingUserProfile(nickname: String) async throws {
        let queries = [URLQueryItem(name: "nickname", value: nickname)]
        let userURL = URLBuilder(host: APIConstants.roomeHost,
                                 path: APIConstants.User.profile.name,
                                 queries: queries)
        guard let url = userURL.url else {
            throw TypeError.bindingFailure
        }
        
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        let requestBuilder = RequestBuilder(url: url, 
                                            method: .get,
                                            headers: header)
        guard let request = requestBuilder.create() else {
            throw TypeError.bindingFailure
        }
        
        profile = try await apiProvider.fetchDecodedData(type: ProfileDTO.self, from: request)
    }
}
