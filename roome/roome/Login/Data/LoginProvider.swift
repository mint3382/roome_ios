//
//  LoginProvider.swift
//  roome
//
//  Created by minsong kim on 5/14/24.
//

import Foundation

enum LoginProvider {
    case apple
    case kakao
    
    var name: String {
        switch self {
        case .apple:
            return "apple"
        case .kakao:
            return "kakao"
        }
    }
}
