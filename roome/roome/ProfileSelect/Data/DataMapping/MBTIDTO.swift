//
//  MBTIDTO.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

enum MBTIDTO: Int, CaseIterable {
    case extroversion = 0
    case introversion
    case intuition
    case sensing
    case thinking
    case feeling
    case judging
    case perceiving
    
    var title: String {
        switch self {
        case .extroversion:
            "E"
        case .introversion:
            "I"
        case .intuition:
            "N"
        case .sensing:
            "S"
        case .thinking:
            "T"
        case .feeling:
            "F"
        case .judging:
            "J"
        case .perceiving:
            "P"
        }
    }
    
    var description: String {
        switch self {
        case .extroversion:
            "외향형"
        case .introversion:
            "내향형"
        case .intuition:
            "직관형"
        case .sensing:
            "현실주의형"
        case .thinking:
            "사고형"
        case .feeling:
            "감정형"
        case .judging:
            "계획형"
        case .perceiving:
            "탐색형"
        }
    }
}
