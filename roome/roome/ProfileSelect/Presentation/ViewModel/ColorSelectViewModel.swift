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
        let tapBackButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let handleCellSelect: AnyPublisher<Void, Error>
        let handleBackButton: AnyPublisher<Void, Never>
        let handleNextPage: AnyPublisher<Void, Never>
        let tapNext: AnyPublisher<Void, Never>
    }
    
    var selectCell = PassthroughSubject<IndexPath, Never>()
    private var loading = PassthroughSubject<Void, Error>()
    private var goToNext = PassthroughSubject<Void, Never>()
    private var useCase: ColorUseCase
    
    init(useCase: ColorUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let tapNext = selectCell
            .compactMap { [weak self] indexPath in
                self?.handlePage(id: indexPath.row + 1)
            }
            .eraseToAnyPublisher()
        
        let cellSelect = loading
            .eraseToAnyPublisher()
        
        let back = input.tapBackButton
            .eraseToAnyPublisher()
        
        let next = goToNext
            .eraseToAnyPublisher()
        
        return Output(handleCellSelect: cellSelect,
                      handleBackButton: back,
                      handleNextPage: next,
                      tapNext: tapNext)
    }
    
    func handlePage(id: Int) {
        Task {
            do {
                try await useCase.colorWithAPI(id: id)
                loading.send()
                try await UserContainer.shared.updateUserProfile()
                try await Task.sleep(nanoseconds: 1_000_000_000)
                goToNext.send()
            } catch {
                loading.send(completion: .failure(error))
            }
        }
    }
}
