//
//  DeviceAndLockViewModel.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import Foundation
import Combine

class DeviceAndLockViewModel {
    struct Input {
        let tapSaveButton = PassthroughSubject<Void, Never>()
        let selectCell = PassthroughSubject<(isEdit: Bool, id: Int), Never>()
        let deselectCell = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        let handleCellSelect = PassthroughSubject<Result<Void, Error>,Never>()
        let handleNextButton = PassthroughSubject<Result<Void, Error>, Never>()
        let handleCanGoNext = PassthroughSubject<Bool, Never>()
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
                    self?.handlePage(id: id)
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
                    handlePage(id: id)
                }
            }
            .store(in: &cancellables)
    }
    
    func handlePage(id: Int) {
        Task {
            do {
                try await useCase.deviceAndLockWithAPI(id: id)
                output.handleNextButton.send(.success({}()))
            } catch {
                output.handleNextButton.send(.failure(error))
            }
        }
    }
}

