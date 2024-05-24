//
//  RoomCountViewModel.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import Foundation
import Combine

class RoomCountViewModel {
    struct Input {
        var count: AnyPublisher<String, Never>
        var nextButton: AnyPublisher<Void, Never>
        var backButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var handleNextButton: AnyPublisher<Bool, Never>
        var handleNextPage: AnyPublisher<Void, Error>
        var handleBackButton: AnyPublisher<Void, Never>
    }
    
    private let usecase: RoomCountUseCase
    private let goToNext = PassthroughSubject<Void, Error>()
    @Published var textInput = "0"
    
    init(usecase: RoomCountUseCase) {
        self.usecase = usecase
    }
    
    func transform(_ input: Input) -> Output {
        let handleNextButton = input.count
            .compactMap { [weak self] count in
                self?.usecase.canGoNext(count)
            }.eraseToAnyPublisher()
        
        let handleNextPage = input.nextButton
            .map { [weak self] _ in
                self?.handlePage(self?.textInput)
            }.compactMap { [weak self] _ in
                self
            }
            .flatMap{ owner in
                owner.goToNext
            }
            .eraseToAnyPublisher()
        
        let handleBackButton = input.backButton
            .eraseToAnyPublisher()
        
        return Output(handleNextButton: handleNextButton, handleNextPage: handleNextPage, handleBackButton: handleBackButton)
    }
    
    func handlePage(_ count: String?) {
        Task {
            do {
                try await usecase.roomCountWithAPI(count, isPlusEnabled: false)
                goToNext.send()
            } catch {
                goToNext.send(completion: .failure(error))
            }
        }
    }
}
