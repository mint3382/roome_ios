//
//  GenreDTO.swift
//  roome
//
//  Created by minsong kim on 5/27/24.
//

import Foundation

enum GenreDTO: Int, CaseIterable {
    case horror = 1
    case thriller 
    case infiltration
    case jailbreak
    case crime
    case action
    case adventure
    case detective
    case mystery
    case sensitivity
    case drama
    case romance
    case fairyTale
    case fantasy
    case SF
    case history
    case comic
    case question
    case outdoor
    
    var title: String {
        switch self {
        case .horror:
            "공포"
        case .thriller:
            "스릴러"
        case .infiltration:
            "잠입"
        case .jailbreak:
            "탈옥"
        case .crime:
            "범죄"
        case .action:
            "액션"
        case .adventure:
            "어드벤처"
        case .detective:
            "추리"
        case .mystery:
            "미스터리"
        case .sensitivity:
            "감성"
        case .drama:
            "드라마"
        case .romance:
            "로맨스"
        case .fairyTale:
            "동화"
        case .fantasy:
            "판타지"
        case .SF:
            "SF"
        case .history:
            "역사"
        case .comic:
            "코믹"
        case .question:
            "문제방"
        case .outdoor:
            "야외"
        }
    }
}
