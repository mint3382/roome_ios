//
//  SettingDTO.swift
//  roome
//
//  Created by minsong kim on 6/23/24.
//

import Foundation

protocol Statable { }

struct SettingDTO {
    
    static let footer = ["앱 버전 1.0.1(3)"]
    
    enum Terms: Int, CaseIterable, Statable {
        case service
        case personal
        
        var title: String {
            switch self {
            case .service:
                "서비스 이용약관"
            case .personal:
                "개인정보 처리방침"
            }
        }
    }
    
    enum Version: Int, CaseIterable, Statable {
        case number
        
        var title: String {
            switch self {
            case .number:
                "앱 버전"
            }
        }
    }
    
    enum SignOut: Int, CaseIterable, Statable {
        case logout
        case withdrawl
        
        var title: String {
            switch self {
            case .logout:
                "로그아웃"
            case .withdrawl:
                "탈퇴하기"
            }
        }
    }
}
