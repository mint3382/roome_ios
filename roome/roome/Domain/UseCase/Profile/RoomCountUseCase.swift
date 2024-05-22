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
    
    func canGoNext(_ text: String) -> Bool {
        let pattern = "^[0-9]{1,5}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        return predicate.evaluate(with: text)
    }
    
    func roomCountWithAPI(_ count: String, isPlusEnabled: Bool) async throws {
        guard let count = Int(count) else {
            throw TypeError.bindingFailure
        }
        
        try await repository.registerCount(count, isPlusEnabled: isPlusEnabled)
    }
}
