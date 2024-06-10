//
//  RoomCountRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import Foundation

protocol RoomCountRepositoryType {
    func registerCount(_ count: Int) async throws
    func registerRange(_ range: (min: Int, max: Int)) async throws
}
