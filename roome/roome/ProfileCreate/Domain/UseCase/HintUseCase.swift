//
//  HintUseCase.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

class HintUseCase {
    private let repository: HintRepositoryType
    
    init(repository: HintRepositoryType) {
        self.repository = repository
    }
    
    func hintWithAPI(id: Int) async throws {
        try await repository.registerHintType(id: id)
    }
}
