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
        let nextState: AnyPublisher<StateDTO, Never>
    }
    
    struct PopUpInput {
        let newButton: AnyPublisher<Void, Never>
        let stillButton: AnyPublisher<Void, Never>
    }
    
    struct PopUpOutput {
        let handleNext: AnyPublisher<Void, Never>
    }
    
    private var goToNext = PassthroughSubject<Bool, Error>()
    private var profileState = PassthroughSubject<StateDTO, Never>()
    
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
        
        let state = profileState
            .eraseToAnyPublisher()
        
        return Output(handleNext: next, nextState: state)
    }
    
    func popUpTransforms(_ input: PopUpInput) -> PopUpOutput {
        let new = input.newButton
            .map { [weak self] _ in
                self?.deleteProfile()
            }
            .compactMap { [weak self] _ in
                self?.profileState.send(.roomCount)
            }.eraseToAnyPublisher()
        
        let still = input.stillButton
            .compactMap { [weak self] _ in
                self?.profileState.send(StateDTO(rawValue: UserContainer.shared.profile!.data.state)!)
            }.eraseToAnyPublisher()
        
        let next = Publishers.Merge(new, still)
            .eraseToAnyPublisher()
        
        return PopUpOutput(handleNext: next)
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
    
    func deleteProfile() {
        Task {
            do {
                try await UserContainer.shared.deleteUserProfile()
            } catch {
                //실패 시? 알림?
                print(error)
            }
        }
    }
}
