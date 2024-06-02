//
//  HintRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

protocol HintRepositoryType {
    func registerHintType(id: Int) async throws
}
