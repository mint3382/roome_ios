//
//  ActivityUseCase.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

class ActivityUseCase {
    private let repository: ActivityRepositoryType
    
    init(repository: ActivityRepositoryType) {
        self.repository = repository
    }
    
    func activityWithAPI(id: Int) async throws {
        try await repository.registerActivity(id: id)
    }
}
