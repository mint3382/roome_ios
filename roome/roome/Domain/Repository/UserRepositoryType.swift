//
//  UserRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/20/24.
//

import Foundation

protocol UserRepositoryType {
    func userWithAPI(decodedDataType: UserDTO.Type) async -> UserDTO?
}
