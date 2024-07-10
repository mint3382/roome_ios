//
//  ColorSelectViewModel.swift
//  roome
//
//  Created by minsong kim on 5/25/24.
//

import Foundation
import Combine

class ColorSelectViewModel {
    struct Input {
        let tapSaveButton = PassthroughSubject<Void, Never>()
        let selectCell = PassthroughSubject<(isEdit: Bool, id: Int), Never>()
        let tapCloseButton = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let handleCellSelect = PassthroughSubject<Result<Void, Error>,Never>()
        let handleNextButton = PassthroughSubject<Result<Void, Error>, Never>()
        let handleCloseButton = PassthroughSubject<Bool, Never>()
        let handleLoading = PassthroughSubject<Bool, Never>()
    }

    private var useCase: ProfileSelectUseCaseType
    private var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    private var id: Int = -1
    
    init(useCase: ProfileSelectUseCaseType) {
        self.useCase = useCase
        self.input = Input()
        self.output = Output()
        settingBind()
    }
    
    func settingBind() {
        input.selectCell
            .sink { [weak self] (isEdit, id) in
                if isEdit {
                    self?.id = id
                } else {
                    self?.handlePage(id: id, isEdit: false)
                }
            }
            .store(in: &cancellables)
        
        input.tapSaveButton
            .sink { [weak self] in
                if let self {
                    handlePage(id: id, isEdit: true)
                }
            }
            .store(in: &cancellables)
        
        input.tapCloseButton
            .sink { [weak self] in
                self?.checkEdit()
            }
            .store(in: &cancellables)
    }
    
    private func checkEdit() {
        let userSelect =  UserContainer.shared.defaultProfile?.data.colors.filter {
            $0.id == id
        }[0].id
        let profileItem = UserContainer.shared.profile?.data.color.map { $0.id }
        
        if userSelect == profileItem {
            output.handleCloseButton.send(false)
        } else {
            output.handleCloseButton.send(true)
        }
    }
    
    private func handlePage(id: Int, isEdit: Bool) {
        Task {
            do {
                try await useCase.colorWithAPI(id: id)
                try await UserContainer.shared.updateUserProfile()
                output.handleLoading.send(isEdit)
                if isEdit == false {
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                }
                output.handleNextButton.send(.success({}()))
            } catch {
                output.handleNextButton.send(.failure(error))
            }
        }
    }
}
