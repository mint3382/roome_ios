//
//  LoginDTO.swift
//  roome
//
//  Created by minsong kim on 5/14/24.
//

struct LoginDTO: Codable {
    let code: Int
    let message: String
    let data: Tokens

    struct Tokens: Codable {
        let accessToken: String
        let refreshToken: String
    }
}
