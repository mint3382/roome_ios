//
//  StrengthDTO.swift
//  roome
//
//  Created by minsong kim on 5/27/24.
//

import Foundation

enum StrengthDTO: Int, CaseIterable{
    case observation = 1
    case analysis
    case reasoning
    case concentration
    case instantly
    case executive
    case creativity
    case composure
    case cooperative
    
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
