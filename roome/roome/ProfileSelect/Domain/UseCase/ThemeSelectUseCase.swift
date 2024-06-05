//
//  ThemeSelectUseCase.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

class ThemeSelectUseCase {
    private let repository: ThemeSelectRepositoryType
    
    init(repository: ThemeSelectRepositoryType) {
        self.repository = repository
    }
    
    func importantThemesWithAPI(ids: [Int]) async throws {
        try await repository.registerThemes(ids: ids)
    }
}
