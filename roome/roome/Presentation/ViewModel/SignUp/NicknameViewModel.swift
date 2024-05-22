//
//  NicknameViewModel.swift
//  roome
//
//  Created by minsong kim on 5/17/24.
//

import UIKit
import Combine

class NicknameViewModel {
    struct NicknameViewModelInput {
        var nickname: AnyPublisher<String, Never>
        var nextButton: AnyPublisher<Void, Never>
    }

    struct NicknameViewModelOutput {
        var isButtonEnable: AnyPublisher<Bool, Never>
        var canGoNext: AnyPublisher<Void, NicknameError>
    }
    
    private let usecase: NicknameUseCase
    private let goToNext = PassthroughSubject<Void, Error>()
    
    init(usecase: NicknameUseCase) {
        self.usecase = usecase
    }
    
    func transform(_ input: NicknameViewModelInput) -> NicknameViewModelOutput {
        //input을 output으로
        let isButtonEnable = input.nickname
            .compactMap { $0 }
            .compactMap { [weak self] in
                self?.usecase.checkNicknameCount($0)
            }.eraseToAnyPublisher()
        
        let canGoNext = Publishers.Zip(input.nickname, input.nextButton)
            .map { [weak self] (nickname, _) in
                self?.pushedNextButton(nickname)
            }
            .compactMap { [weak self] _ in
                self
            }
            .flatMap{ owner in
                owner.goToNext
            }
            .mapError { error -> NicknameError in
                guard let error = error as? NetworkError else {
                    return NicknameError.network
                }
                switch error {
                case .failureCode(let errorDTO):
                    return NicknameError.form(errorDTO)
                default:
                    return NicknameError.network
                }
            }
            .eraseToAnyPublisher()
        
        return NicknameViewModelOutput(isButtonEnable: isButtonEnable, canGoNext: canGoNext)
    }
    
    func canFillTextField(_ text: String) -> Bool {
        if usecase.checkNicknameText(text) {
            return true
        } else {
            return false
        }
    }
    
    func pushedNextButton(_ nickname: String) {
        Task {
            do {
                try await usecase.nicknameCheckWithAPI(nickname)
                try await UserContainer.shared.updateUserInformation()
                goToNext.send()
            } catch {
                goToNext.send(completion: .failure(error))
            }
        }
    }
}

enum NicknameError: Error {
    case network
    case form(ErrorDTO)
}
