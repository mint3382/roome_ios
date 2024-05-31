//
//  DislikeRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

protocol DislikeRepositoryType {
    func registerDislikes(ids: [Int]) async throws
}
