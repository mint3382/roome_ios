//
//  LoginRepositoryType.swift
//  roome
//
//  Created by minsong kim on 5/14/24.
//

import Foundation

protocol LoginRepositoryType {
    func requestLogin(body json: [String: Any], decodedDataType: LoginDTO.Type) async -> LoginDTO?
    func requestLogOut() async throws
    func requestSignOut(body json: [String: Any?]) async throws
}
