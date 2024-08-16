//
//  UserProfileRepositoryType.swift
//  roome
//
//  Created by minsong kim on 7/8/24.
//

import UIKit

protocol UserProfileRepositoryType {
    func requestNickname(_ name: String) async throws
    func requestImage(_ image: UIImage) async throws
    func requestImageDelete() async throws
}
