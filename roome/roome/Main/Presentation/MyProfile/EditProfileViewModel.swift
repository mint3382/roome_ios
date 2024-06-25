//
//  EditProfileViewModel.swift
//  roome
//
//  Created by minsong kim on 6/25/24.
//

import Foundation
import Combine

class EditProfileViewModel {
    struct Input {
        let tappedSaveButton = PassthroughSubject<Void, Never>()
        let tappedTakeAPhotoButton = PassthroughSubject<Void, Never>()
        let tappedGetPhotoFromAlbumButton = PassthroughSubject<Void, Never>()
        let tappedBaseImageButton = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let handleSaveButton = PassthroughSubject<Void, NicknameError>()
    }
    
    let input: Input
    let output: Output
    
    @Published var textInput = UserContainer.shared.user?.data.nickname ?? ""
    
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
        
        input.tappedTakeAPhotoButton
            .sink { [weak self] in
                //TODO: - 사진 촬영 구현
            }
            .store(in: &cancellables)
        
        input.tappedGetPhotoFromAlbumButton
            .sink { [weak self] in
                //TODO: - 앨범에서 이미지 가져오기 구현
            }
            .store(in: &cancellables)
        
        input.tappedBaseImageButton
            .sink { [weak self] in
                //TODO: - 프로필 이미지 삭제, 기본 이미지로 설정
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
