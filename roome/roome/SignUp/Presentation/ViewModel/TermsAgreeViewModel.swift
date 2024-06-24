//
//  TermsOfServiceViewModel.swift
//  roome
//
//  Created by minsong kim on 5/19/24.
//

import Foundation
import Combine


struct TermsButtonStates {
    var allAgree: Bool = false
    var ageAgree: Bool = false
    var service: Bool = false
    var personal: Bool = false
}

class TermsAgreeViewModel {
    var buttonStates = TermsButtonStates()
    var termsUseCase: TermsAgreeUseCase?
    
    struct Input {
        let allAgree = PassthroughSubject<Void, Never>()
        let ageAgree = PassthroughSubject<Void, Never>()
        let service = PassthroughSubject<Bool, Never>()
        let personal = PassthroughSubject<Bool, Never>()
        let next = PassthroughSubject<Void, Never>()
        let state = PassthroughSubject<Void, Never>()
        let handleDetail = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let isNextButtonOn = PassthroughSubject<Bool, Never>()
        let isAllAgreeOn = PassthroughSubject<Bool, Never>()
        let states = PassthroughSubject<TermsButtonStates, Never>()
        let goToNext = PassthroughSubject<Void, Error>()
    }

    var detailState: TermsDetailStates = .service
    
    let input: Input
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    
    init(termsUseCase: TermsAgreeUseCase?) {
        self.termsUseCase = termsUseCase
        self.input = Input()
        self.output = Output()
        settingBind()
    }
    
    func settingBind() {
        input.allAgree
            .sink { [weak self] in
                guard let self else { return }
                self.buttonStates.allAgree.toggle()
                
                if self.buttonStates.allAgree {
                    self.buttonStates.ageAgree = true
                    self.buttonStates.service = true
                    self.buttonStates.personal = true
                    
                    output.isNextButtonOn.send(true)
                    output.isAllAgreeOn.send(true)
                } else {
                    self.buttonStates.ageAgree = false
                    self.buttonStates.service = false
                    self.buttonStates.personal = false
                    
                    output.isNextButtonOn.send(false)
                    output.isAllAgreeOn.send(false)
                }
                input.state.send()
            }
            .store(in: &cancellables)
        
        input.ageAgree
            .sink { [weak self] in
                guard let self else { return }
                buttonStates.ageAgree.toggle()
                input.state.send()
            }
            .store(in: &cancellables)
        
        input.service
            .sink { [weak self] isDetail in
                guard let self else { return }
                if isDetail {
                    buttonStates.service = true
                } else {
                    buttonStates.service.toggle()
                }
                input.state.send()
            }
            .store(in: &cancellables)
        
        input.personal
            .sink { [weak self] isDetail in
                guard let self else { return }
                if isDetail {
                    buttonStates.personal = true
                } else {
                    buttonStates.personal.toggle()
                }
                input.state.send()
            }
            .store(in: &cancellables)
        
        input.state
            .sink { [weak self] in
                guard let self else { return }
                
                if buttonStates.ageAgree == true, 
                    buttonStates.service == true,
                    buttonStates.personal == true {
                    buttonStates.allAgree = true
                    output.isAllAgreeOn.send(true)
                    output.isNextButtonOn.send(true)
                } else {
                    buttonStates.allAgree = false
                    output.isAllAgreeOn.send(false)
                    output.isNextButtonOn.send(false)
                }
                output.states.send(buttonStates)
            }
            .store(in: &cancellables)
        
        input.next
            .sink { [weak self] _ in
                self?.pushedNextButton()
            }
            .store(in: &cancellables)
        
        input.handleDetail
            .sink { [weak self] in
                guard let self else { return }
                switch detailState {
                case .service:
                    input.service.send(true)
                case .personal:
                    input.personal.send(true)
                }
            }
            .store(in: &cancellables)
    }
}

extension TermsAgreeViewModel {
    func pushedNextButton() {
        Task {
            do {
                try await termsUseCase?.termsWithAPI(states: buttonStates)
                output.goToNext.send()
            } catch {
                output.goToNext.send(completion: .failure(error))
            }
        }
    }
}
