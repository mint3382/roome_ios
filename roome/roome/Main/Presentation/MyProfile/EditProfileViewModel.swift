//
//  EditProfileViewModel.swift
//  roome
//
//  Created by minsong kim on 6/25/24.
//

import UIKit
import Combine

class EditProfileViewModel {
    struct Input {
        let tappedSaveButton = PassthroughSubject<Void, Never>()
        let tappedCloseButton = PassthroughSubject<Void, Never>()
        let changePhoto = CurrentValueSubject<UIImage, Error>(UserContainer.shared.userImage)
    }
    
    struct Output {
        let handleSaveButton = PassthroughSubject<Void, NicknameError>()
        let handleCloseButton = PassthroughSubject<Bool, Never>()
    }
    
    let input: Input
    let output: Output
    
    @Published var textInput = UserContainer.shared.user?.data.nickname ?? ""
    
    private var userImage: UIImage = UserContainer.shared.userImage
    private var userNickname: String? = UserContainer.shared.user?.data.nickname
    var isImageChanged: Bool = false
    
    private let usecase: NicknameUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(usecase: NicknameUseCase) {
        self.usecase = usecase
        self.input = Input()
        self.output = Output()
        settingBind()
    }
    
    private func settingBind() {
        input.tappedSaveButton
            .sink { [weak self] _ in
                print(self?.textInput ?? "에러")
                self?.pushedNextButton(self?.textInput)
            }
            .store(in: &cancellables)
        
        input.changePhoto
            .sink { completion in
                switch completion {
                case .finished:
                    print("changePhoto finished")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] image in
                self?.userImage = image
            }
            .store(in: &cancellables)

        input.tappedCloseButton
            .sink { [weak self] in
                guard let self else {
                    return
                }
                if (textInput == "" || textInput == userNickname)
                    && isImageChanged == false {
                    output.handleCloseButton.send(false)
                } else {
                    output.handleCloseButton.send(true)
                }
            }
            .store(in: &cancellables)
    }
    
    func canFillTextField() -> Bool {
        if usecase.checkNicknameText(textInput) {
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
                self.output.handleSaveButton.send()
            } catch(let error) {
                guard let error = error as? NicknameError else {
                    self.output.handleSaveButton.send(completion: .failure(NicknameError.network))
                    return
                }
                
                switch error {
                case .form(let errorDTO):
                    self.output.handleSaveButton.send(completion: .failure(NicknameError.form(errorDTO)))
                default:
                    self.output.handleSaveButton.send(completion: .failure(NicknameError.network))
                }
            }
        }
    }
}
