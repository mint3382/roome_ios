//
//  UserProfileUseCase.swift
//  roome
//
//  Created by minsong kim on 7/8/24.
//

import UIKit

class UserProfileUseCase {
    private let userProfileRepository: UserProfileRepositoryType
    
    init(userProfileRepository: UserProfileRepositoryType) {
        self.userProfileRepository = userProfileRepository
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
    
    func nicknameCheckWithAPI(_ text: String?) async throws {
        guard let text else {
            throw TypeError.bindingFailure
        }
        
        try await userProfileRepository.requestNickname(text)
    }
    
    func imageWithAPI(_ image: UIImage) async throws {
        try await userProfileRepository.requestImage(image)
    }

    func deleteImageWithAPI() async throws {
        try await userProfileRepository.requestImageDelete()
    }
}
