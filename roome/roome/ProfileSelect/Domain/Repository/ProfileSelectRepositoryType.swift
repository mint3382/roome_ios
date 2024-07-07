//
//  ProfileSelectRepositoryType.swift
//  roome
//
//  Created by minsong kim on 7/2/24.
//

import Foundation

protocol ProfileSelectRepositoryType {
    func registerCount(_ count: Int) async throws
    func registerRange(_ range: (min: Int, max: Int)) async throws
    func registerGenre(ids: [Int]) async throws
    func registerMbti(mbti: String) async throws
    func registerStrengths(ids: [Int]) async throws
    func registerThemes(ids: [Int]) async throws
    func registerHorrors(id: Int) async throws
    func registerHintType(id: Int) async throws
    func registerDeviceLock(id: Int) async throws
    func registerActivity(id: Int) async throws
    func registerDislikes(ids: [Int]) async throws
    func registerColor(id: Int) async throws
}
