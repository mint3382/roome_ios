//
//  NetworkError.swift
//  roome
//
//  Created by minsong kim on 5/13/24.
//

import Foundation

enum NetworkError: Error {
    case invalidStatus(Int)
    case failureCode(ErrorDTO)
    case noResponse
}
