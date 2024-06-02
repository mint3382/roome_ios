//
//  HorrorThemeUseCase.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

class HorrorThemeUseCase {
    private let repository: HorrorThemeRepositoryType
    
    init(repository: HorrorThemeRepositoryType) {
        self.repository = repository
    }
    
    func horrorThemesWithAPI(id: Int) async throws {
        try await repository.registerHorrors(id: id)
    }
}
