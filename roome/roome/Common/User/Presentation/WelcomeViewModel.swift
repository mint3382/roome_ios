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
        let nextButton = PassthroughSubject<Void, Never>()
        let newButton = PassthroughSubject<Void, Never>()
        let stillButton = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let willBeContinue = PassthroughSubject<Bool, Error>()
        let handleNext = PassthroughSubject<StateDTO, Never>()
    }
    
    let input: Input
    let output: Output
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.input = Input()
        self.output = Output()
        settingBind()
    }
    
    private func settingBind() {
        input.nextButton
            .sink { [weak self] in
                self?.handlePage()
            }
            .store(in: &cancellables)
        
        input.newButton
            .sink { [weak self] in
                self?.deleteProfile()
                self?.output.handleNext.send(.roomCountRanges)
            }
            .store(in: &cancellables)
        
        input.stillButton
            .sink { [weak self] in
                self?.output.handleNext.send(StateDTO(rawValue: UserContainer.shared.profile!.data.state)!)
            }
            .store(in: &cancellables)
    }
    
    private func handlePage() {
        Task {
            do {
                try await UserContainer.shared.updateUserProfile()
                try await UserContainer.shared.updateDefaultProfile()
                UserContainer.shared.updateUserImage(url: URL(string: UserContainer.shared.user?.data.imageUrl ?? ""))
                if UserContainer.shared.profile == nil || UserContainer.shared.profile?.data.state == StateDTO.roomCountRanges.rawValue {
                    output.willBeContinue.send(false)
                } else {
                    output.willBeContinue.send(true)
                }
            } catch {
                print(error)
                output.willBeContinue.send(completion: .failure(error))
            }
        }
    }
    
    private func deleteProfile() {
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
