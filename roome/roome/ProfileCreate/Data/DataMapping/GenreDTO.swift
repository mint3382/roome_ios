//
//  GenreDTO.swift
//  roome
//
//  Created by minsong kim on 5/27/24.
//

import Foundation

enum GenreDTO: Int, CaseIterable {
    case horror = 1
    case thriller = 2
    case infiltration = 3
    case jailbreak = 4
    case crime = 5
    case action = 6
    case adventure = 7
    case detective = 8
    case mystery = 9
    case sensitivity = 10
    case drama = 11
    case romance = 12
    case fairyTale = 13
    case fantasy = 14
    case SF = 15
    case history = 16
    case comic = 17
    case question = 18
    case outdoor = 19
    
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
