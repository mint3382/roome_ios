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
        case signOut
        
        var name: String {
            switch self {
            case .signIn:
                "/signin"
            case .withdrawal:
                "/withdrawal"
            case .token:
                "/token"
            case .signOut:
                "/signout"
            }
        }
    }
    
    enum User {
        case users
        case termsAgree
        case nickname
        case nicknameValidation
        
        var name: String {
            switch self{
            case .users:
                "/users"
            case .termsAgree:
                "/users/terms-agreement"
            case .nickname:
                "/users/nickname"
            case .nicknameValidation:
                "/users/nickname/validation"
            }
        }
    }
    
    enum Profile: String {
        case profiles = "/profiles"
        case defaults = "/profiles/defaults"
        case roomCount = "/profiles/room-count"
        case roomRange = "/profiles/room-count-range"
        case genre = "/profiles/preferred-genres"
        case mbti = "/profiles/mbti"
        case horror = "/profiles/horror-theme-position"
        case hint = "/profiles/hint-usage-preference"
        case device = "/profiles/device-lock-preference"
        case color = "/profiles/color"
        case activity = "/profiles/activity"
        case strengths = "/profiles/user-strengths"
        case important = "/profiles/theme-important-factors"
        case dislike = "/profiles/theme-disliked-factors"
    }
}
