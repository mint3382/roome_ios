//
//  HorrorThemePositionDTO.swift
//  roome
//
//  Created by minsong kim on 5/27/24.
//

import Foundation

enum HorrorThemePositionDTO: Int, CaseIterable {
    case extreme = 1
    case very
    case half
    case inevitably
    case noFear
    case enjoy
    case noExperience
    
    var title: String {
        switch self {
        case .extreme:
            "극쫄"
        case .very:
            "쫄"
        case .half:
            "변쫄"
        case .inevitably:
            "마지모텡"
        case .noFear:
            "탱"
        case .enjoy:
            "극탱"
        case .noExperience:
            "잘 모르겠어요"
        }
    }
    
    var description: String {
        switch self {
        case .extreme:
            "사소한 거에도 놀랄 정도로 겁이 많아요"
        case .very:
            "겁이 많은 편이에요"
        case .half:
            "무서워하지만, 공포 테마는 좋아요"
        case .inevitably:
            "무서워하지만, 쫄들 사이에서 탱 포지션이에요"
        case .noFear:
            "무서워하지 않아요"
        case .enjoy:
            "공포를 오히려 즐겨요"
        case .noExperience:
            "혹은 공포 테마 경험이 없어요"
        }
    }
}
