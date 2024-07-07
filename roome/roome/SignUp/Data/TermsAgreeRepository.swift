//
//  TermsAccessRepository.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import Foundation

class TermsAgreeRepository: TermsAgreeRepositoryType {
    func requestTerms(states: TermsButtonStates) async throws {
        let termsURL = URLBuilder(host: APIConstants.roomeHost, path: APIConstants.User.termsAgree.name, queries: nil)
        guard let url = termsURL.url else {
            throw TypeError.bindingFailure
        }
        
        let body: [String: Any] = ["ageOverFourteen": states.ageAgree,
                                   "serviceAgreement": states.service,
                                   "personalInfoAgreement": states.personal,
                                   "marketingAgreement": false]
        
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
