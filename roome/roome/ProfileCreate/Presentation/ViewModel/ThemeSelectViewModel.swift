//
//  ThemeSelectViewModel.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import Foundation
import Combine

class ThemeSelectViewModel {
    struct Input {
        let tapNextButton: AnyPublisher<Void, Never>
        let tapBackButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let handleCellSelect: AnyPublisher<(Bool, IndexPath), Never>
        let handleNextButton: AnyPublisher<Void, Error>
        let canGoNext: AnyPublisher<Bool, Never>
        let handleBackButton: AnyPublisher<Void, Never>
    }
    
    var selectCell = PassthroughSubject<IndexPath, Never>()
    var deselectCell = PassthroughSubject<IndexPath, Never>()
    private var canGoNext = PassthroughSubject<Int,Never>()
    private var goToNext = PassthroughSubject<Void, Error>()
    private var list = Set<IndexPath>()
    private var useCase: ThemeSelectUseCase
    
    init(useCase: ThemeSelectUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let handleCellSelect = selectCell
            .compactMap {
                $0
            }
            .compactMap { [weak self] item in
                self?.canSelectCount(item)
            }
            .eraseToAnyPublisher()
        
        let cellSelect = Publishers.Zip(handleCellSelect, deselectCell)
            .eraseToAnyPublisher()
        
        let canGoNext = canGoNext
            .map { count in
                0 < count && count <= 2
            }.eraseToAnyPublisher()
        
        let handleNextButton = input.tapNextButton
            .map { [weak self] _ in
                self?.handlePage()
            }
            .compactMap { [weak self] _ in
                self
            }
            .flatMap{ owner in
                owner.goToNext
            }
            .eraseToAnyPublisher()
        
        let back = input.tapBackButton
            .eraseToAnyPublisher()
        
        return Output(handleCellSelect: cellSelect, 
                      handleNextButton: handleNextButton,
                      canGoNext: canGoNext,
                      handleBackButton: back)
    }
    
    func deselectItem(_ item: IndexPath) {
        if list.contains(item) {
            list.remove(item)
            canGoNext.send(list.count)
        }
    }
    
    func canSelectCount(_ item: IndexPath) -> Bool? {
        deselectCell.send(item)
        if list.count < 2 {
            list.insert(item)
            canGoNext.send(list.count)
            return true
        } else {
            return false
        }
    }
    
    func handlePage() {
        Task {
            do {
                let ids = list.map { $0.row + 1 }
                try await useCase.importantThemesWithAPI(ids: ids)
                goToNext.send()
            } catch {
                goToNext.send(completion: .failure(error))
            }
        }
    }
}
