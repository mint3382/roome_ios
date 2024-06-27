//
//  NicknameViewModel.swift
//  roome
//
//  Created by minsong kim on 5/17/24.
//

import UIKit
import Combine

class NicknameViewModel {
    struct Input {
        let enteredNickname = CurrentValueSubject<String, Never>("")
        let tappedNextButton = PassthroughSubject<Void, Never>()
        let tappedBackButton = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let isButtonEnable = PassthroughSubject<Bool, Never>()
        let handleNextButton = PassthroughSubject<Result<Void, Error>, Never>()
        let handleBackButton = PassthroughSubject<Void, Never>()
    }
    
    let input: Input
    let output: Output
    
    private let usecase: NicknameUseCase
    private var cancellables = Set<AnyCancellable>()
    
    @Published var textInput = ""
    
    init(usecase: NicknameUseCase) {
        self.usecase = usecase
        self.input = Input()
        self.output = Output()
        settingBind()
    }
    
    func settingBind() {
        input.enteredNickname
            .sink { [weak self] nickname in
                guard let isButtonEnable = self?.usecase.checkNicknameCount(nickname) else {
                    self?.output.isButtonEnable.send(false)
                    return
                }
                
                self?.output.isButtonEnable.send(isButtonEnable)
            }
            .store(in: &cancellables)
        
        input.tappedNextButton
            .sink { [weak self] in
                self?.pushedNextButton(self?.textInput)
            }
            .store(in: &cancellables)
    }
    
   
//            .mapError { error -> NicknameError in
//                guard let error = error as? NetworkError else {
//                    return NicknameError.network
//                }
//                switch error {
//                case .failureCode(let errorDTO):
//                    return NicknameError.form(errorDTO)
//                default:
//                    return NicknameError.network
//                }
    
    func canFillTextField(_ text: String) -> Bool {
        if usecase.checkNicknameText(text) {
            return true
        } else {
            return false
        }
    }
    
    private func pushedNextButton(_ nickname: String?) {
        Task {
            do {
                try await usecase.nicknameCheckWithAPI(nickname)
                try await UserContainer.shared.updateUserInformation()
                output.handleNextButton.send(.success({}()))
            } catch {
                output.handleNextButton.send(.failure(error))
            }
        }
    }
}

enum NicknameError: Error {
    case network
    case form(ErrorDTO)
}
