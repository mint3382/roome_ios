//
//  DeviceLockDTO.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

enum DeviceLockDTO {
    case device
    case lock
    case both
    
    var id: Int {
        switch self {
        case .device:
            1
        case .lock:
            2
        case .both:
            3
        }
    }
    
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
