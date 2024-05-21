//
//  NicknameRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import Foundation

protocol NicknameRepositoryType {
    func requestNickname(_ name: String) async throws
}
