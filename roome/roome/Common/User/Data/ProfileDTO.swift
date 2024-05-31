//
//  ProfileDTO.swift
//  roome
//
//  Created by minsong kim on 5/31/24.
//

import Foundation

struct ProfileDTO: Codable {
    let data: Profile
    
    struct Profile: Codable {
        let id: Int
        let state: String
        let count: Int
        let isPlusEnabled: Bool
        let preferredGenres: [Detail]
        let mbti: String
        let userStrengths: [Detail]
        let themeImportantFactors: [Detail]
        let horrorThemePosition: Detail
        let hintUsagePreference: Detail
        let deviceLockPreference: Detail
        let activity: Detail
        let themeDislikedFactors: [Detail]
        let color: ColorDTO
        
        struct Detail: Codable {
            let id: Int
            let title: String
        }
        
        struct ColorDTO: Codable {
            let id: Int
            let title: String
            let mode: String
            let shape: String
            let direction: String
            let startColor: String
            let endColor: String
        }
    }
}
