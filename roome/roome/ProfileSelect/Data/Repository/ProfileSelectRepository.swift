//
//  ProfileSelectRepository.swift
//  roome
//
//  Created by minsong kim on 7/2/24.
//

import Foundation

class ProfileSelectRepository: ProfileSelectRepositoryType {
    func registerCount(_ count: Int) async throws {
        let url = try checkURL(.roomCountRanges)
        let body: [String: Any] = ["count": count]
        
        try await registerWithURL(url, and: body)
    }
    
    func registerRange(_ range: (min: Int, max: Int)) async throws {
        let URL = URLBuilder(host: APIConstants.roomeHost,
                             path: APIConstants.Profile.roomRange.rawValue,
                             queries: nil)
        guard let url = URL.url else {
            throw TypeError.bindingFailure
        }
        
        let body: [String: Any] = ["minCount": range.min,
                                   "maxCount": range.max]
        
        try await registerWithURL(url, and: body)
    }
    
    func registerGenre(ids: [Int]) async throws {
        let url = try checkURL(.genres)
        let body: [String: Any] = ["ids": ids]
        
        try await registerWithURL(url, and: body)
    }
    
    func registerMbti(mbti: String) async throws {
        let url = try checkURL(.mbti)
        let body: [String: Any] = ["mbti": mbti]
        
        try await registerWithURL(url, and: body)
    }
    
    func registerStrengths(ids: [Int]) async throws {
        let url = try checkURL(.strengths)
        let body: [String: Any] = ["ids": ids]
        
        try await registerWithURL(url, and: body)
    }
    
    func registerThemes(ids: [Int]) async throws {
        let url = try checkURL(.themes)
        let body: [String: Any] = ["ids": ids]
        
        try await registerWithURL(url, and: body)
    }
    
    func registerHorrors(id: Int) async throws {
        let url = try checkURL(.horrorPosition)
        let body: [String: Any] = ["id": id]
        
        try await registerWithURL(url, and: body)
    }
    
    func registerHintType(id: Int) async throws {
        let url = try checkURL(.hint)
        let body: [String: Any] = ["id": id]
        
        try await registerWithURL(url, and: body)
    }
    
    func registerDeviceLock(id: Int) async throws {
        let url = try checkURL(.device)
        let body: [String: Any] = ["id": id]
        
        try await registerWithURL(url, and: body)
    }
    
    func registerActivity(id: Int) async throws {
        let url = try checkURL(.activity)
        let body: [String: Any] = ["id": id]
        
        try await registerWithURL(url, and: body)
    }
    
    func registerDislikes(ids: [Int]) async throws {
        let url = try checkURL(.dislike)
        let body: [String: Any] = ["ids": ids]
        
        try await registerWithURL(url, and: body)
    }
    
    func registerColor(id: Int) async throws {
        let url = try checkURL(.color)
        let body: [String: Any] = ["id": id]
        
        try await registerWithURL(url, and: body)
    }
    
    private func registerWithURL(_ url: URL, and body: [String: Any]) async throws {
        let accessToken = KeyChain.read(key: .accessToken) ?? ""
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        
        let requestBuilder = RequestBuilder(url: url,
                                            method: .put,
                                            bodyJSON: body,
                                            headers: header)
        guard let request = requestBuilder.create() else {
            throw  TypeError.bindingFailure
        }
        
        _ = try await APIProvider().fetchData(from: request)
    }
    
    private func checkURL(_ state: StateDTO) throws -> URL {
        let path: APIConstants.Profile = {
            switch state {
            case .roomCountRanges:
                    .roomCount
            case .genres:
                    .genre
            case .mbti:
                    .mbti
            case .strengths:
                    .strengths
            case .themes:
                    .important
            case .horrorPosition:
                    .horror
            case .hint:
                    .hint
            case .device:
                    .device
            case .activity:
                    .activity
            case .dislike:
                    .dislike
            case .color:
                    .color
            default:
                    .defaults
            }
        }()
        
        let URL = URLBuilder(host: APIConstants.roomeHost,
                             path: path.rawValue,
                             queries: nil)
        guard let url = URL.url else {
            throw TypeError.bindingFailure
        }
        
        return url
    }
}
