//
//  ActivityRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

protocol ActivityRepositoryType {
    func registerActivity(id: Int) async throws
}
