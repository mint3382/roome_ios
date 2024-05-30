//
//  ImportantFactorDTO.swift
//  roome
//
//  Created by minsong kim on 5/27/24.
//

import Foundation

enum ImportantFactorDTO {
    case story
    case direction
    case probability
    case interior
    case scale
    case new
    case logical
    
    var id: Int {
        switch self {
        case .story:
            1
        case .direction:
            2
        case .probability:
            3
        case .interior:
            4
        case .scale:
            5
        case .new:
            6
        case .logical:
            7
        }
    }
    
    var title: String {
        switch self {
        case .story:
            "탄탄한 스토리"
        case .direction:
            "다양한 연출"
        case .probability:
            "명확한 개연성"
        case .interior:
            "퀄리티 높은 인테리어"
        case .scale:
            "커다란 스케일"
        case .new:
            "신선한 문제"
        case .logical:
            "논리적인 문제"
        }
    }
}
