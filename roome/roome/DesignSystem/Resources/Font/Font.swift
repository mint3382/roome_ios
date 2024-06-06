//
//  Font.swift
//  roome
//
//  Created by minsong kim on 5/17/24.
//

import Foundation

enum Font {
    enum Name {
        case pretendardBold
        case pretendardMedium
        case pretendardRegular
        
        var file: String {
            switch self {
            case .pretendardBold:
                "Pretendard-Bold"
            case .pretendardMedium:
                "Pretendard-Medium"
            case .pretendardRegular:
                "Pretendard-Regular"
            }
        }
    }
    
    enum Size: CGFloat {
        case _11 = 11
        case _12 = 12
        case _14 = 14
        case _16 = 16
        case _20 = 20
        case _22 = 22
        case _24 = 24
        case _28 = 28
        case _32 = 32
        case _50 = 50
    }
}
