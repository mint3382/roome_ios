//
//  DeviceLockDTO.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

enum DeviceLockDTO: Int, CaseIterable {
    case device = 1
    case lock
    case both
    
    var title: String {
        switch self {
        case .device:
            "장치"
        case .lock:
            "자물쇠"
        case .both:
            "장치&자물쇠 모두"
        }
    }
}
