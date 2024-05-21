//
//  TermsAccessRepository.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import Foundation

class TermsAgreeRepository: TermsAgreeRepositoryType {
    func requestTerms(states: TermsButtonStates) async throws {
        let loginURL = URLBuilder(host: APIConstants.roomeHost, path: APIConstants.UserPath.termsAgree.name, queries: nil)
        guard let url = loginURL.url else {
            throw TypeError.bindingFailure
        }
        
        let body: [String: Any] = ["ageOverFourteen": states.allAgree,
                                   "serviceAgreement": states.service,
                                   "personalInfoAgreement": states.personal,
                                   "marketingAgreement": states.advertise]
        
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        
        let requestBuilder = RequestBuilder(url: url, method: .put, bodyJSON: body, headers: header)
        guard let request = requestBuilder.create() else {
            throw  TypeError.bindingFailure
        }
        
        _ = try await APIProvider().fetchData(from: request)
    }
}
