//
//  GenreUseCase.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

class GenreUseCase {
    private let repository: GenreRepositoryType
    
    init(repository: GenreRepositoryType) {
        self.repository = repository
    }
    
    func genresWithAPI(ids: [Int]) async throws {
        try await repository.registerGenre(ids: ids)
    }
}
