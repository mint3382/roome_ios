//
//  LoginDTO.swift
//  roome
//
//  Created by minsong kim on 5/14/24.
//

struct LoginDTO: Decodable {
    let code: Int
    let message: String
    let data: Tokens

    struct Tokens: Decodable {
        let accessToken: String
        let refreshToken: String
    }
}
