//
//  StrengthUseCase.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

class StrengthUseCase {
    private let repository: StrengthRepositoryType
    
    init(repository: StrengthRepositoryType) {
        self.repository = repository
    }
    
    func strengthsWithAPI(ids: [Int]) async throws {
        try await repository.registerStrengths(ids: ids)
    }
}
