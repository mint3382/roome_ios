//
//  ProfileSelectUseCase.swift
//  roome
//
//  Created by minsong kim on 7/2/24.
//

import Foundation

class ProfileSelectUseCase: ProfileSelectUseCaseType {
    private let repository: ProfileSelectRepositoryType
    
    init(repository: ProfileSelectRepositoryType) {
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
    
    func genresWithAPI(ids: [Int]) async throws {
        try await repository.registerGenre(ids: ids)
    }
    
    func mbtiWithAPI(mbti: [String]) async throws {
        var input: String
        input = mbti.joined()
        try await repository.registerMbti(mbti: input)
    }
    
    func strengthsWithAPI(ids: [Int]) async throws {
        try await repository.registerStrengths(ids: ids)
    }
    
    func importantThemesWithAPI(ids: [Int]) async throws {
        try await repository.registerThemes(ids: ids)
    }
    
    func horrorThemesWithAPI(id: Int) async throws {
        try await repository.registerHorrors(id: id)
    }
    
    func hintWithAPI(id: Int) async throws {
        try await repository.registerHintType(id: id)
    }
    
    func deviceAndLockWithAPI(id: Int) async throws {
        try await repository.registerDeviceLock(id: id)
    }
    
    func activityWithAPI(id: Int) async throws {
        try await repository.registerActivity(id: id)
    }
    
    func dislikeWithAPI(ids: [Int]) async throws {
        try await repository.registerDislikes(ids: ids)
    }
    
    func colorWithAPI(id: Int) async throws {
        try await repository.registerColor(id: id)
    }
}
