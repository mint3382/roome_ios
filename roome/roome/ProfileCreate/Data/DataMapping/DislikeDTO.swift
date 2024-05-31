//
//  DislikeDTO.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

enum DislikeDTO: Int, CaseIterable {
    case math = 1
    case hardWork
    case longSentence
    case sounds
    case darkLight
    case difficulty
    case questions
    case forcedEmotion
    case forcedActivity
    
    var title: String {
        switch self {
        case .math:
            "이과형 문제"
        case .hardWork:
            "노가다 문제"
        case .longSentence:
            "긴 지문"
        case .sounds:
            "삑딱쿵"
        case .darkLight:
            "낮은 조도"
        case .difficulty:
            "높은 난이도"
        case .questions:
            "문제방"
        case .forcedEmotion:
            "억지 감동"
        case .forcedActivity:
            "억지 활동성"
        }
    }
}
