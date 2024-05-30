//
//  HintDTO.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

enum HintDTO {
    case noHint
    case atLeast
    case doNotCare
    
    var id: Int {
        switch self {
        case .noHint:
            1
        case .atLeast:
            2
        case .doNotCare:
            3
        }
    }
    
    var title: String {
        switch self {
        case .noHint:
            "힌트 안써요"
        case .atLeast:
            "최소한의 힌트만"
        case .doNotCare:
            "힌트 사용 괜찮아요"
        }
    }
    
    var description: String {
        switch self {
        case .noHint:
            "막히더라도 사용하지 않아요"
        case .atLeast:
            "시간이 오래 걸릴 때만 써요"
        case .doNotCare:
            "조금만 막혀도 바로 사용해요"
        }
    }
}
