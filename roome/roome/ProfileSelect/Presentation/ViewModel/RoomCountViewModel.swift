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
        var rangeButton: AnyPublisher<Void, Never>
        var textButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var handleNextButton: AnyPublisher<Bool, Never>
        var handleNextPage: AnyPublisher<Void, Error>
        var handleBackButton: AnyPublisher<Void, Never>
        var handleRangeOrText: AnyPublisher<Bool, Never>
        var tapNext: AnyPublisher<Void, Never>
    }
    
    private let usecase: RoomCountUseCase
    private let goToNext = PassthroughSubject<Void, Error>()
    private let canGoNext = PassthroughSubject<Bool, Never>()
    @Published var textInput = "0"
    
    init(usecase: RoomCountUseCase) {
        self.usecase = usecase
    }
    
    func transform(_ input: Input) -> Output {
        let handleNextButton = input.count
            .compactMap { [weak self] count in
                self?.usecase.canGoNext(count)
            }.eraseToAnyPublisher()
        
        let goNext = Publishers.Merge(handleNextButton, canGoNext)
            .eraseToAnyPublisher()
        
        let tapNext = input.nextButton
            .compactMap { [weak self] _ in
                self?.handlePage(self?.textInput)
            }
            .eraseToAnyPublisher()
        
        let handleNextPage = input.nextButton
            .compactMap { [weak self] _ in
                self
            }
            .flatMap{ owner in
                owner.goToNext
            }
            .eraseToAnyPublisher()
        
        let handleBackButton = input.backButton
            .eraseToAnyPublisher()
        
        let range = input.rangeButton
            .map { [weak self] _ in
                self?.canGoNext.send(false)
            }
            .map {
                true
            }
            .eraseToAnyPublisher()
        
        let textButton = input.textButton
            .map { [weak self] _ in
                self?.canGoNext.send(true)
            }
            .map {
                false
            }
            .eraseToAnyPublisher()
        
        let handleRangeOrText = Publishers.Merge(range, textButton)
            .eraseToAnyPublisher()
        
        return Output(handleNextButton: goNext,
                      handleNextPage: handleNextPage,
                      handleBackButton: handleBackButton,
                      handleRangeOrText: handleRangeOrText,
                      tapNext: tapNext)
    }
    
    func handlePage(_ count: String?) {
        Task {
            do {
                try await usecase.roomCountWithAPI(count)
                goToNext.send()
            } catch {
                goToNext.send(completion: .failure(error))
            }
        }
    }
}
