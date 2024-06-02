//
//  ActivitiesDTO.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

enum ActivitiesDTO: Int, CaseIterable {
    case high = 1
    case middle
    case low
    case atLeast
    
    var title: String {
        switch self {
        case .high:
            "높은 활동성"
        case .middle:
            "중간 활동성"
        case .low:
            "낮은 활동성"
        case .atLeast:
            "활동성 최소"
        }
    }
    
    var description: String {
        switch self {
        case .high:
            "걷고, 뛰고, 계단 이동하는 게 좋아요"
        case .middle:
            "땀나지 않을 정도로 적당히 움직이는 게 좋아요"
        case .low:
            "걷는 정도가 좋아요"
        case .atLeast:
            "최소한의 이동만 있는 게 좋아요"
        }
    }
}
