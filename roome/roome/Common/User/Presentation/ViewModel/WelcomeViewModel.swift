//
//  WelcomeViewModel.swift
//  roome
//
//  Created by minsong kim on 5/21/24.
//

import Foundation
import Combine

class WelcomeViewModel {
    struct Input {
        let nextButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let handleNext: AnyPublisher<Bool, Error>
    }
    private var goToNext = PassthroughSubject<Bool, Error>()
    
    func transforms(_ input: Input) -> Output {
        let next = input.nextButton
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
        
        return Output(handleNext: next)
    }
    
    func handlePage() {
        Task {
            do {
                try await UserContainer.shared.updateUserProfile()
                if UserContainer.shared.profile == nil {
                    goToNext.send(false)
                } else {
                    goToNext.send(true)
                }
            } catch {
                goToNext.send(completion: .failure(error))
            }
        }
    }
}
