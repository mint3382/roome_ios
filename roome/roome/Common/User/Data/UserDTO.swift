//
//  UserDTO.swift
//  roome
//
//  Created by minsong kim on 5/20/24.
//

import Foundation

struct UserDTO: Codable {
    let code: Int
    let message: String
    let data: User

    struct User: Codable {
        let state: String
        let email: String
        let nickname: String
        let imageUrl: String
    }
}

enum UserState: String {
    case termsAgreement = "termsAgreement"
    case nickname = "nickname"
    case registrationCompleted = "registrationCompleted"
}
