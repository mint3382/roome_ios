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
        
        guard let httpResponse = response as? HTTPURLResponse,              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidStatus
        }
        
        print(httpResponse.statusCode)
        return data
    }
    
    func fetchDecodedData<T: Decodable>(type: T.Type, from request: URLRequest) async throws -> T {
        let data = try await fetchData(from: request)
        let jsonData = try JSONDecoder().decode(type, from: data)
        
        return jsonData
    }
}
