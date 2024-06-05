//
//  ColorUseCase.swift
//  roome
//
//  Created by minsong kim on 5/31/24.
//

import Foundation

class ColorUseCase {
    private let repository: ColorRepositoryType
    
    init(repository: ColorRepositoryType) {
        self.repository = repository
    }
    
    func colorWithAPI(id: Int) async throws {
        try await repository.registerColor(id: id)
    }
}
