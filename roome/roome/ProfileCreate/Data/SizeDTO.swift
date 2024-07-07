//
//  SizeDTO.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import Foundation

enum SizeDTO: Int, CaseIterable {
    case square = 0
    case rectangle
    
    var title: String {
        switch self {
        case .square:
            "1:1 정방향"
        case .rectangle:
            "3:4 세로형"
        }
    }
}
