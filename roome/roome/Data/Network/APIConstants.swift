//
//  APIConstants.swift
//  roome
//
//  Created by minsong kim on 5/14/24.
//

struct APIConstants {
    static let roomeHost = "roome.site"
    
    enum Path {
        case signIn
        case withdrawal
        
        var name: String {
            switch self {
            case .signIn:
                "/signin"
            case.withdrawal:
                "/withdrawal"
            }
        }
    }
}
