//
//  DislikeUseCase.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

class DislikeUseCase {
    private let repository: DislikeRepositoryType
    
    init(repository: DislikeRepositoryType) {
        self.repository = repository
    }
    
    func dislikeWithAPI(ids: [Int]) async throws {
        try await repository.registerDislikes(ids: ids)
    }
}
