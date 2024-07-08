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
        let changePhoto = PassthroughSubject<Result<UIImage, Error>, Never>()
    }
    
    struct Output {
        let handleSaveButton = PassthroughSubject<Result<Void, NicknameError>, Never>()
        let handleCloseButton = PassthroughSubject<Bool, Never>()
        let handleBaseImage = PassthroughSubject<Result<Void, Error>, Never>()
    }
    
    let input: Input
    let output: Output
    
    @Published var textInput = UserContainer.shared.user?.data.nickname ?? ""
    
    private var userImage: UIImage = UserContainer.shared.userImage
    private var userNickname: String? = UserContainer.shared.user?.data.nickname
    var isImageChanged: ImageState = .notChange
    
    enum ImageState {
        case change
        case notChange
        case reset
    }
    
    private let usecase: UserProfileUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(usecase: UserProfileUseCase) {
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
            .sink { [weak self] result in
                switch result {
                case .success(let image):
                    self?.userImage = image
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)

        input.tappedCloseButton
            .sink { [weak self] in
                guard let self else {
                    return
                }
                if (textInput == "" || textInput == userNickname)
                    && isImageChanged == .notChange {
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
                if (textInput != "" && textInput != userNickname) {
                    try await usecase.nicknameCheckWithAPI(nickname)
                }
                if isImageChanged == .change {
                    try await usecase.imageWithAPI(userImage.resize(newWidth: 50))
                } else if isImageChanged == .reset {
                    try await usecase.deleteImageWithAPI()
                }
                try await UserContainer.shared.updateUserInformation()
                self.output.handleSaveButton.send(.success({}()))
            } catch(let error) {
                guard let error = error as? NicknameError else {
                    self.output.handleSaveButton.send(.failure(NicknameError.network))
                    return
                }
                
                switch error {
                case .form(let errorDTO):
                    self.output.handleSaveButton.send(.failure(NicknameError.form(errorDTO)))
                default:
                    self.output.handleSaveButton.send(.failure(NicknameError.network))
                }
            }
        }
    }
}
