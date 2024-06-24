//
//  SettingDTO.swift
//  roome
//
//  Created by minsong kim on 6/23/24.
//

import Foundation

enum SettingSection: Hashable {
    case terms
    case version
    case signOut
}

enum SettingItem: Hashable {
    case service
    case personal
    case version
    case logout
    case withdrawal
    
    var title: String {
        switch self {
        case .service:
            "서비스 이용약관"
        case .personal:
            "개인정보 처리방침"
        case .version:
            "앱 버전"
        case .logout:
            "로그아웃"
        case .withdrawal:
            "탈퇴하기"
        }
    }
}
