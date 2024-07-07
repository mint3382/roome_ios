//
//  URLBuilder.swift
//  roome
//
//  Created by minsong kim on 5/13/24.
//

import Foundation

struct URLBuilder {
    private let scheme: String
    private let host: String
    private let path: String
    private let queries: [URLQueryItem]?
    
    init(scheme: String = "https",
         host: String,
         path: String,
         queries: [URLQueryItem]?) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queries = queries
    }
    
    var url: URL? {
        var component = URLComponents()
        
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = configureQuery(queries)
        
        return component.url
    }
    
    private func configureQuery(_ query: [URLQueryItem]?) -> [URLQueryItem] {
        var queries: [URLQueryItem] = []
        
        query?.forEach({ URLQueryItem in
            queries.append(URLQueryItem)
        })
        
        return queries
    }
}
