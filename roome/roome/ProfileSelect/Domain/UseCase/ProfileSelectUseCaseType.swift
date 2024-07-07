//
//  ProfileSelectUseCaseType.swift
//  roome
//
//  Created by minsong kim on 7/2/24.
//

import Foundation

protocol ProfileSelectUseCaseType {
    func roomCountWithAPI(_ count: String?) async throws
    func roomRangeWithAPI(_ range: (min: Int, max: Int)) async throws
    func genresWithAPI(ids: [Int]) async throws
    func mbtiWithAPI(mbti: [String]) async throws
    func strengthsWithAPI(ids: [Int]) async throws
    func importantThemesWithAPI(ids: [Int]) async throws
    func horrorThemesWithAPI(id: Int) async throws
    func hintWithAPI(id: Int) async throws
    func deviceAndLockWithAPI(id: Int) async throws
    func activityWithAPI(id: Int) async throws
    func dislikeWithAPI(ids: [Int]) async throws
    func colorWithAPI(id: Int) async throws
}
