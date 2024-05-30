//
//  GenreRepository.swift
//  roome
//
//  Created by minsong kim on 5/30/24.
//

import Foundation

class GenreRepository: GenreRepositoryType {
    func registerGenre(ids: [Int]) async throws {
        let genreURL = URLBuilder(host: APIConstants.roomeHost,
                                  path: APIConstants.Profile.genre.rawValue,
                                     queries: nil)
        guard let url = genreURL.url else {
            throw TypeError.bindingFailure
        }
        
        let body: [String: Any] = ["ids": ids]
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
