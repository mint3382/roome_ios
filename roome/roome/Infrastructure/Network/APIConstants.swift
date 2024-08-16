//
//  APIConstants.swift
//  roome
//
//  Created by minsong kim on 5/14/24.
//

struct APIConstants {
    static let roomeHost = "roome.asia"
    
    enum Auth {
        case signIn
        case withdrawal
        case token
        case signOut
        
        var name: String {
            switch self {
            case .signIn:
                "/auth/signin"
            case .withdrawal:
                "/auth/deactivate"
            case .token:
                "/auth/token"
            case .signOut:
                "/auth/signout"
            }
        }
    }
    
    enum User {
        case users
        case termsAgree
        case nickname
        case nicknameValidation
        case image
        case profile
        
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
            case .image:
                "/users/image"
            case .profile:
                "/users/profile"
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
    
    enum Version: String {
        case iOS = "/versions/ios"
    }
}
