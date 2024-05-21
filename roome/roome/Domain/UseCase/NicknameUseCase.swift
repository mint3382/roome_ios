//
//  NicknameUseCase.swift
//  roome
//
//  Created by minsong kim on 5/18/24.
//

import Foundation

class NicknameUseCase {
    private let nicknameRepository: NicknameRepositoryType
    
    init(nicknameRepository: NicknameRepositoryType) {
        self.nicknameRepository = nicknameRepository
    }
    
    func checkNicknameText(_ text: String) -> Bool {
        let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{0,8}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", pattern)
        return predicate.evaluate(with: text)
    }
    
    func checkNicknameCount(_ text: String) -> Bool {
        if text.count > 1 && text.count < 9 {
            return true
        } else {
            return false
        }
    }
    
    func nicknameCheckWithAPI(_ text: String) async throws {
        try await nicknameRepository.requestNickname(text)
    }
}
