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
        let nickname: AnyPublisher<String, Never>
        let nextButton: AnyPublisher<Void, Never>
        let back: AnyPublisher<Void, Never>
    }

    struct NicknameViewModelOutput {
        let isButtonEnable: AnyPublisher<Bool, Never>
        let canGoNext: AnyPublisher<Void, Never>
        let goToNext: AnyPublisher<Void, NicknameError>
        let handleBackButton: AnyPublisher<Void, Never>
    }
    
    private let usecase: NicknameUseCase
    private let goToNext = PassthroughSubject<Void, Error>()
    @Published var textInput = ""
    
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
        
        let canGoNext = input.nextButton
            .compactMap { [weak self] _ in
                self?.pushedNextButton(self?.textInput)
            }
            .eraseToAnyPublisher()
        
        let next = goToNext
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
        
        let back = input.back
            .eraseToAnyPublisher()
        
        return NicknameViewModelOutput(isButtonEnable: isButtonEnable, canGoNext: canGoNext,goToNext: next, handleBackButton: back)
    }
    
    func canFillTextField(_ text: String) -> Bool {
        if usecase.checkNicknameText(text) {
            return true
        } else {
            return false
        }
    }
    
    func pushedNextButton(_ nickname: String?) {
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
