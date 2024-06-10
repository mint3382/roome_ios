//
//  RoomCountUseCase.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import Foundation

class RoomCountUseCase {
    private let repository: RoomCountRepositoryType
    
    init(repository: RoomCountRepositoryType) {
        self.repository = repository
    }
    
    func roomCountWithAPI(_ count: String?) async throws {
        guard let count = Int(count ?? "") else {
            throw TypeError.bindingFailure
        }
        
        try await repository.registerCount(count)
    }
    
    func roomRangeWithAPI(_ range: (min: Int, max: Int)) async throws {
        try await repository.registerRange(range)
    }
}
