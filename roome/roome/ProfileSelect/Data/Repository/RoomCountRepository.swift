//
//  RoomCountRepository.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import Foundation

class RoomCountRepository: RoomCountRepositoryType {
    func registerCount(_ count: Int) async throws {
        let URL = URLBuilder(host: APIConstants.roomeHost,
                             path: APIConstants.Profile.roomCount.rawValue,
                             queries: nil)
        guard let url = URL.url else {
            throw TypeError.bindingFailure
        }
        
        
        let body: [String: Any] = ["count": count]
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
    
    func registerRange(_ range: (min: Int, max: Int)) async throws {
        let URL = URLBuilder(host: APIConstants.roomeHost,
                             path: APIConstants.Profile.roomRange.rawValue,
                             queries: nil)
        guard let url = URL.url else {
            throw TypeError.bindingFailure
        }
        
        
        let body: [String: Any] = ["minCount": range.min,
                                   "maxCount": range.max]
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
}