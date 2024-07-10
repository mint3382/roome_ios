//
//  StrengthViewModel.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import Foundation
import Combine

class StrengthViewModel {
    struct Input {
        let tapNextButton = PassthroughSubject<Void, Never>()
        let selectCell = PassthroughSubject<IndexPath, Never>()
        let deselectCell = PassthroughSubject<IndexPath, Never>()
    }
    
    struct Output {
        let handleCellSelect = PassthroughSubject<(Bool, IndexPath), Never>()
        let handleNextButton = PassthroughSubject<Result<Void, Error>, Never>()
        let handleCanGoNext = PassthroughSubject<Bool, Never>()
    }

    var list = Set<IndexPath>()
    private let useCase: ProfileSelectUseCaseType
    private var cancellables = Set<AnyCancellable>()
    let input: Input
    let output: Output
    
    init(useCase: ProfileSelectUseCaseType) {
        self.useCase = useCase
        self.input = Input()
        self.output = Output()
        settingBind()
    }
    
    func settingBind() {
        input.selectCell
            .sink { [weak self] indexPath in
                if let isSelect = self?.canSelectCount(indexPath) {
                    self?.output.handleCellSelect.send((isSelect, indexPath))
                }
            }
            .store(in: &cancellables)
        
        input.deselectCell
            .sink { [weak self] indexPath in
                self?.deselectItem(indexPath)
            }
            .store(in: &cancellables)
        
        input.tapNextButton
            .sink { [weak self] in
                self?.handlePage()
            }
            .store(in: &cancellables)
    }
    
    private func deselectItem(_ item: IndexPath) {
        if list.contains(item) {
            list.remove(item)
            checkNextButton()
        }
    }
    
    private func canSelectCount(_ item: IndexPath) -> Bool? {
        if list.count < 2 {
            list.insert(item)
            checkNextButton()
            return true
        } else {
            return false
        }
    }
    
    private func checkNextButton() {
        if 0 < list.count, list.count <= 2 {
            output.handleCanGoNext.send(true)
        } else {
            output.handleCanGoNext.send(false)
        }
    }
    
    private func handlePage() {
        Task {
            do {
                let ids = self.list.compactMap { UserContainer.shared.defaultProfile?.data.strengths[$0.row].id }
                try await useCase.strengthsWithAPI(ids: ids)
                output.handleNextButton.send(.success({}()))
            } catch {
                output.handleNextButton.send(.failure(error))
            }
        }
    }
}
