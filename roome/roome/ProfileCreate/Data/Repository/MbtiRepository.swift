//
//  MbtiRepository.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

class MbtiRepository: MbtiRepositoryType {
    func registerMbti(mbti: String) async throws {
        let URL = URLBuilder(host: APIConstants.roomeHost,
                             path: APIConstants.Profile.mbti.rawValue,
                                     queries: nil)
        guard let url = URL.url else {
            throw TypeError.bindingFailure
        }
        
        let body: [String: Any] = ["mbti": mbti]
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
