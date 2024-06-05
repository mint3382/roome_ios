//
//  ThemeSelectRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

protocol ThemeSelectRepositoryType {
    func registerThemes(ids: [Int]) async throws
}
