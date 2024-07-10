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
        let deselectCell = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        let handleCellSelect = PassthroughSubject<Result<Void, Error>,Never>()
        let handleNextButton = PassthroughSubject<Result<Void, Error>, Never>()
        let handleCanGoNext = PassthroughSubject<Bool, Never>()
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
                    self?.output.handleCanGoNext.send(true)
                } else {
                    self?.handlePage(id: id, isEdit: false)
                }
            }
            .store(in: &cancellables)
        
        input.deselectCell
            .sink { [weak self] id in
                self?.id = -1
                self?.output.handleCanGoNext.send(false)
            }
            .store(in: &cancellables)
        
        input.tapSaveButton
            .sink { [weak self] in
                if let self {
                    handlePage(id: id, isEdit: true)
                }
            }
            .store(in: &cancellables)
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
