//
//  GenreRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

protocol GenreRepositoryType {
    func registerGenre(ids: [Int]) async throws
}
