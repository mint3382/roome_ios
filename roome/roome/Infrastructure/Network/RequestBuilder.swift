//
//  RequestBuilder.swift
//  roome
//
//  Created by minsong kim on 5/13/24.
//

import Foundation

struct RequestBuilder {
    private let url: URL
    private let method: HTTPMethod
    private let bodyJSON: [String: Any?]?
    private let headers: [String: String]

    init(url: URL,
         method: HTTPMethod,
         bodyJSON: [String: Any]? = nil,
         headers: [String: String] = ["Content-Type": "application/json"]) {

        self.url = url
        self.method = method
        self.bodyJSON = bodyJSON
        self.headers = headers
    }

    func create() -> URLRequest? {
        var request = URLRequest(url: url)
        
        if let bodyJSON {
            request.httpBody = makeRequestBody(with: bodyJSON)
        }
        
        request.httpMethod = method.typeName
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    private func makeRequestBody(with json: [String: Any]) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        return jsonData
    }
}
