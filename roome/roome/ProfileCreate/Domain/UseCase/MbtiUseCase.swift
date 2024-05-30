//
//  MbtiUseCase.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

class MbtiUseCase {
    private let repository: MbtiRepositoryType
    
    init(repository: MbtiRepositoryType) {
        self.repository = repository
    }
    
    func mbtiWithAPI(mbti: [String]) async throws {
        var input: String
        if mbti.isEmpty {
            input = "none"
        } else {
            input = mbti.joined()
        }
        try await repository.registerMbti(mbti: input)
    }
}
