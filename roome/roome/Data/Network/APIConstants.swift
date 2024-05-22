//
//  APIConstants.swift
//  roome
//
//  Created by minsong kim on 5/14/24.
//

struct APIConstants {
    static let roomeHost = "roome.site"
    
    enum Auth {
        case signIn
        case withdrawal
        case token
        
        var name: String {
            switch self {
            case .signIn:
                "/signin"
            case .withdrawal:
                "/withdrawal"
            case .token:
                "/token"
            }
        }
    }
    
    enum User {
        case users
        case termsAgree
        case nickname
        
        var name: String {
            switch self{
            case .users:
                "/users"
            case .termsAgree:
                "/users/terms-agreement"
            case .nickname:
                "/users/nickname"
            }
        }
    }
    
    enum Profile: String {
        case roomCount = "/profiles/room-count"
    }
}
