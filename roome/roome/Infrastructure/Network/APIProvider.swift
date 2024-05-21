//
//  APIProvider.swift
//  roome
//
//  Created by minsong kim on 5/13/24.
//

import Foundation

class APIProvider {
    private func fetchData(from request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }
           
        if (200...299).contains(httpResponse.statusCode) {
            return data
        } else if httpResponse.statusCode == 401 {
            let newData = try await retryWithUpdateToken(request: request)
            return newData
        } else {
            print(httpResponse.statusCode)
            throw NetworkError.invalidStatus(httpResponse.statusCode)
        }
    }
    
    func fetchDecodedData<T: Decodable>(type: T.Type, from request: URLRequest) async throws -> T {
        let data = try await fetchData(from: request)
        let jsonData = try JSONDecoder().decode(type, from: data)
        
        return jsonData
    }
}

extension APIProvider {
    private func retry(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }
        if (200...299).contains(httpResponse.statusCode) {
            return data
        } else {
            print(httpResponse.statusCode)
            throw NetworkError.invalidStatus(httpResponse.statusCode)
        }
    }
    
    private func refreshAccessToken() async throws -> LoginDTO? {
        let userURL = URLBuilder(host: APIConstants.roomeHost,
                                 path: APIConstants.AuthPath.token.name,
                                 queries: nil)
        guard let url = userURL.url else {
            return nil
        }
        
        let refreshToken = KeyChain.read(key: .refreshToken) ?? ""
        let body: [String: Any] = ["refreshToken": refreshToken]
        let requestBuilder = RequestBuilder(url: url, method: .post, bodyJSON: body)
        guard let request = requestBuilder.create() else {
            return nil
        }
        
        let data = try await retry(request: request)
        
        let jsonData = try JSONDecoder().decode(LoginDTO.self, from: data)
        
        return jsonData
    }
    
    private func updateToken(request: URLRequest) async throws -> URLRequest {
        guard let tokens = try await refreshAccessToken() else {
            throw NetworkError.noResponse
        }
        
        KeyChain.update(key: .accessToken, data: tokens.data.accessToken)
        KeyChain.update(key: .refreshToken, data: tokens.data.refreshToken)
        
        var newRequest = request
        newRequest.setValue("Bearer \(tokens.data.accessToken)", forHTTPHeaderField: "Authorization")
        
        return newRequest
    }
    
    private func retryWithUpdateToken(request: URLRequest) async throws -> Data {
        var newRequest = try await updateToken(request: request)
        let data = try await retry(request: newRequest)
        
        return data
    }
}
