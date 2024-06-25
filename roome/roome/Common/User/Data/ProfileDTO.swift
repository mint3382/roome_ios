//
//  ProfileDTO.swift
//  roome
//
//  Created by minsong kim on 5/31/24.
//

import Foundation

struct MyProfileDTO {
    static let category = ["방탈출 횟수", "MBTI", "선호 장르", "강점", "테마 중요 요소", "공포테마 포지션", "힌트 선호도", "장치/자물쇠 선호도", "활동성 선호도", "싫어하는 요소", "프로필 색상"]
}

struct ProfileDTO: Codable {
    let data: Profile
    
    struct Profile: Codable {
        let nickname: String
        let state: String
        let count: String
        let preferredGenres: [Detail]
        let mbti: String
        let userStrengths: [Detail]
        let themeImportantFactors: [Detail]
        let horrorThemePosition: Detail?
        let hintUsagePreference: Detail?
        let deviceLockPreference: Detail?
        let activity: Detail?
        let themeDislikedFactors: [Detail]
        let color: ColorDTO?
        
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
    
    var bundle: [[String?]] {
        [
            [data.count],
            [data.mbti],
            data.preferredGenres.map { $0.title },
            data.userStrengths.map { $0.title },
            data.themeImportantFactors.map { $0.title },
            [data.horrorThemePosition?.title],
            [data.hintUsagePreference?.title],
            [data.deviceLockPreference?.title],
            [data.activity?.title],
            data.themeDislikedFactors.map { $0.title }
        ]
    }
        
}
