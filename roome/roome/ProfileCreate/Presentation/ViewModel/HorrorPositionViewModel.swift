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
    }
    
    var selectCell = PassthroughSubject<IndexPath, Never>()
    private var goToNext = PassthroughSubject<Void, Error>()
    private var useCase: HorrorThemeUseCase
    
    init(useCase: HorrorThemeUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let cellSelect = selectCell
            .map { [weak self] indexPath in
                self?.handlePage(id: indexPath.row + 1)
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
                      handleBackButton: back)
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

