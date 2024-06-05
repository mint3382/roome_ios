//
//  MbtiRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

protocol MbtiRepositoryType {
    func registerMbti(mbti: String) async throws
}
