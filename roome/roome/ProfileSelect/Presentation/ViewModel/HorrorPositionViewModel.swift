//
//  HorrorPositionViewModel.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import Foundation
import Combine

class HorrorPositionViewModel {
    struct Input {
        let tapBackButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let handleCellSelect: AnyPublisher<Void, Error>
        let handleBackButton: AnyPublisher<Void, Never>
        let tapNext: AnyPublisher<Void, Never>
    }
    
    var selectCell = PassthroughSubject<Int, Never>()
    private var goToNext = PassthroughSubject<Void, Error>()
    private var useCase: ProfileSelectUseCaseType
    
    init(useCase: ProfileSelectUseCaseType) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let tapNext = selectCell
            .compactMap { [weak self] id in
                self?.handlePage(id: id)
            }
            .eraseToAnyPublisher()
        
        let cellSelect = goToNext
            .eraseToAnyPublisher()
        
        let back = input.tapBackButton
            .eraseToAnyPublisher()
        
        return Output(handleCellSelect: cellSelect,
                      handleBackButton: back,
                      tapNext: tapNext)
    }
    
    func handlePage(id: Int) {
        Task {
            do {
                try await useCase.horrorThemesWithAPI(id: id)
                goToNext.send()
            } catch {
                goToNext.send(completion: .failure(error))
            }
        }
    }
}

