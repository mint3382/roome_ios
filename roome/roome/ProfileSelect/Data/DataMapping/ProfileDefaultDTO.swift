//
//  ProfileDefaultDTO.swift
//  roome
//
//  Created by minsong kim on 7/10/24.
//

import Foundation

struct ProfileDefaultDTO: Codable {
    let code: Int
    let message: String
    let data: DataClass

    // MARK: - DataClass
    struct DataClass: Codable {
        let roomCountRanges: [RoomCountRange]
        let genres: [Activity]
        let strengths: [Activity]
        let importantFactors: [Activity]
        let horrorThemePositions: [Activity2]
        let hintUsagePreferences: [Activity2]
        let deviceLockPreferences: [Activity2]
        let activities: [Activity2]
        let dislikedFactors: [Activity]
        let colors: [Color]
    }
    
    // MARK: - RoomCountRange
    struct RoomCountRange: Codable {
        let id: Int
        let title: String
        let minCount: Int
        let maxCount: Int
    }

    // MARK: - Activity
    struct Activity: Codable {
        let id: Int
        let title: String
    }
    
    struct Activity2: Codable {
        let id: Int
        let title: String
        let description: String
    }

    // MARK: - Color
    struct Color: Codable {
        let id: Int
        let title: String
        let mode: String
        let shape: String
        let direction: String
        let startColor: String
        let endColor: String
    }
}
