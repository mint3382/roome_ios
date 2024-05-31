//
//  DeviceLockUseCase.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

class DeviceLockUseCase {
    private let repository: DeviceLockRepositoryType
    
    init(repository: DeviceLockRepositoryType) {
        self.repository = repository
    }
    
    func deviceAndLockWithAPI(id: Int) async throws {
        try await repository.registerDeviceLock(id: id)
    }
}
