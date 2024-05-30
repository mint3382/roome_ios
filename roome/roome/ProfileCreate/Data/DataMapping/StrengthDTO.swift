//
//  StrengthDTO.swift
//  roome
//
//  Created by minsong kim on 5/27/24.
//

import Foundation

enum StrengthDTO {
    case observation
    case analysis
    case reasoning
    case concentration
    case instantly
    case executive
    case creativity
    case composure
    case cooperative
    
    var id: Int {
        switch self {
        case .observation:
            1
        case .analysis:
            2
        case .reasoning:
            3
        case .concentration:
            4
        case .instantly:
            5
        case .executive:
            6
        case .creativity:
            7
        case .composure:
            8
        case .cooperative:
            9
        }
    }
    
    var title: String {
        switch self {
        case .observation:
            "관찰력"
        case .analysis:
            "분석력"
        case .reasoning:
            "추리력"
        case .concentration:
            "집중력"
        case .instantly:
            "순발력"
        case .executive:
            "실행력"
        case .creativity:
            "창의력"
        case .composure:
            "침착함"
        case .cooperative:
            "협업 능력"
        }
    }
}
