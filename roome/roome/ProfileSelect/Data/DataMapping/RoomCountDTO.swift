//
//  RoomCountDTO.swift
//  roome
//
//  Created by minsong kim on 6/6/24.
//

import Foundation

enum RoomCountDTO: Int, CaseIterable {
    case zero = 1
    case thirtyOne
    case sixtyOne
    case oneHundred
    case oneHundredFiftyOne
    case twoHundredOne
    case overThreeHundredOne
    
    var title: String {
        switch self {
        case .zero:
            "0~30번"
        case .thirtyOne:
            "31~60번"
        case .sixtyOne:
            "61~99번"
        case .oneHundred:
            "100~150번"
        case .oneHundredFiftyOne:
            "151~200번"
        case .twoHundredOne:
            "201~300번"
        case .overThreeHundredOne:
            "301번 이상"
        }
    }
    
    var minCount: Int {
        switch self {
        case .zero:
            0
        case .thirtyOne:
            31
        case .sixtyOne:
            61
        case .oneHundred:
            100
        case .oneHundredFiftyOne:
            151
        case .twoHundredOne:
            201
        case .overThreeHundredOne:
            301
        }
    }
    
    var maxCount: Int {
        switch self {
        case .zero:
            30
        case .thirtyOne:
            60
        case .sixtyOne:
            99
        case .oneHundred:
            150
        case .oneHundredFiftyOne:
            200
        case .twoHundredOne:
            300
        case .overThreeHundredOne:
            99999
        }
    }
}
