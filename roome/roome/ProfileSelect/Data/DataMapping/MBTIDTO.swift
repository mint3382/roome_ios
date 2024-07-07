//
//  MBTIDTO.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

enum MBTIDTO {
    enum EI: Int {
        case extroversion
        case introversion
        
        var title: String {
            switch self {
            case .extroversion:
                "E"
            case .introversion:
                "I"
            }
        }
        
        var description: String {
            switch self {
            case .extroversion:
                "외향형"
            case .introversion:
                "내향형"
            }
        }
    }
    
    enum NS: Int {
        case intuition
        case sensing
        
        var title: String {
            switch self {
            case .intuition:
                "N"
            case .sensing:
                "S"
            }
        }
        
        var description: String {
            switch self {
            case .intuition:
                "직관형"
            case .sensing:
                "현실주의형"
            }
        }
    }
    
    enum TF: Int {
        case thinking
        case feeling
        
        var title: String {
            switch self {
            case .thinking:
                "T"
            case .feeling:
                "F"
            }
        }
        
        var description: String {
            switch self {
            case .thinking:
                "사고형"
            case .feeling:
                "감정형"
            }
        }
    }
    
    enum JP: Int {
        case judging
        case perceiving
        
        var title: String {
            switch self {
            case .judging:
                "J"
            case .perceiving:
                "P"
            }
        }
        
        var description: String {
            switch self {
            case .judging:
                "계획형"
            case .perceiving:
                "탐색형"
            }
        }
    }
}
