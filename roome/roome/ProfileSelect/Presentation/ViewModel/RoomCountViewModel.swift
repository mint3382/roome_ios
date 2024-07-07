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
        var rangeButton: AnyPublisher<Void, Never>
        var textButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var handleNextButton: AnyPublisher<Bool, Never>
        var handleNextPage: AnyPublisher<Void, Error>
        var handleRangeOrText: AnyPublisher<Bool, Never>
        var tapNext: AnyPublisher<Void, Never>
    }
    
    private let usecase: ProfileSelectUseCaseType
    private let goToNext = PassthroughSubject<Void, Error>()
    @Published var textInput = "0"
    private var isRangeState: Bool = true
    var isSelected: (min: Int, max: Int) = (0,0)
    let canGoNext = PassthroughSubject<Bool, Never>()
    
    init(usecase: ProfileSelectUseCaseType) {
        self.usecase = usecase
    }
    
    func transform(_ input: Input) -> Output {
        let goNext = canGoNext
            .eraseToAnyPublisher()
        
        let tapNext = input.nextButton
            .compactMap { [weak self] _ in
                self
            }
            .compactMap { owner in
                if owner.isRangeState {
                    owner.handlePage(range: owner.isSelected)
                } else {
                    owner.handlePage(count: owner.textInput)
                }
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
        
        let range = input.rangeButton
            .map { [weak self] _ in
                self?.isRangeState = true
            }
            .compactMap { [weak self] _ in
                self
            }
            .map { owner in
                owner.isSelected
            }
            .map { [weak self] (min, max) in
                if max == 0 {
                    self?.canGoNext.send(false)
                } else {
                    self?.canGoNext.send(true)
                }
            }
            .map {
                true
            }
            .eraseToAnyPublisher()
        
        let textButton = input.textButton
            .map { [weak self] _ in
                self?.isRangeState = false
            }
            .compactMap { [weak self] _ in
                self
            }
            .map { owner in
                owner.textInput.count
            }
            .map { [weak self] count in
                if count == 0 {
                    self?.canGoNext.send(false)
                } else {
                    self?.canGoNext.send(true)
                }
            }
            .map {
                false
            }
            .eraseToAnyPublisher()
        
        let handleRangeOrText = Publishers.Merge(range, textButton)
            .eraseToAnyPublisher()
        
        return Output(handleNextButton: goNext,
                      handleNextPage: handleNextPage,
                      handleRangeOrText: handleRangeOrText,
                      tapNext: tapNext)
    }
    
    func handlePage(count: String?) {
        Task {
            do {
                try await usecase.roomCountWithAPI(count)
                goToNext.send()
            } catch {
                goToNext.send(completion: .failure(error))
            }
        }
    }
    
    func handlePage(range: (min: Int, max: Int)) {
        Task {
            do {
                try await usecase.roomRangeWithAPI(range)
                goToNext.send()
            } catch {
                goToNext.send(completion: .failure(error))
            }
        }
    }
}
