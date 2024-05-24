//
//  TermsAgreeUseCase.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import Foundation

class TermsAgreeUseCase {
    private let termsAgreeRepository: TermsAgreeRepositoryType
    
    init(termsAgreeRepository: TermsAgreeRepositoryType) {
        self.termsAgreeRepository = termsAgreeRepository
    }
    
    func termsWithAPI(states: TermsButtonStates) async throws {
        try await termsAgreeRepository.requestTerms(states: states)
    }
}
