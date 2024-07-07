//
//  NicknameRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import UIKit

protocol NicknameRepositoryType {
    func requestNickname(_ name: String) async throws
//    func requestImage(_ image: UIImage) async throws
//    func requestImageDelete() async throws
}
