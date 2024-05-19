//
//  TermsOfServiceViewModel.swift
//  roome
//
//  Created by minsong kim on 5/19/24.
//

import Foundation
import Combine


class TermsOfServiceViewModel {
    struct ButtonStates {
        var allAgree: Bool = false
        var ageAgree: Bool = false
        var service: Bool = false
        var personal: Bool = false
        var advertise: Bool = false
    }
    
    var buttonStates = ButtonStates()
    
    struct TermsOfServiceInput {
        let allAgree: AnyPublisher<Void, Never>
        let ageAgree: AnyPublisher<Void, Never>
        let service: AnyPublisher<Void, Never>
        let personal: AnyPublisher<Void, Never>
        let advertise: AnyPublisher<Void, Never>
    }
    
    struct TermsOfServiceOutput {
        let isAllAgreeOn: AnyPublisher<Bool, Never>
        let isNextButtonOn: AnyPublisher<Bool, Never>
        let states: AnyPublisher<ButtonStates, Never>
    }
    
    func transform(_ input: TermsOfServiceInput) -> TermsOfServiceOutput {
        let all = input.allAgree
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self else { return }
                self.buttonStates.allAgree.toggle()
                
                if self.buttonStates.allAgree {
                    self.buttonStates.ageAgree = true
                    self.buttonStates.service = true
                    self.buttonStates.personal = true
                    self.buttonStates.advertise = true
                } else {
                    self.buttonStates.ageAgree = false
                    self.buttonStates.service = false
                    self.buttonStates.personal = false
                    self.buttonStates.advertise = false
                }
            }).share()
        
        let age = input.ageAgree
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.buttonStates.ageAgree.toggle()
            })
            .share()
        
        let service = input.service
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.buttonStates.service.toggle()
            })
            .share()
        
        let personal = input.personal
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.buttonStates.personal.toggle()
            })
            .share()
    
        let advertise = input.advertise
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.buttonStates.advertise.toggle()
            }).share()
        
        let state = Publishers.Merge5(all, age, service, personal, advertise)
            .compactMap { [weak self] _ in
                self?.buttonStates
            }.eraseToAnyPublisher()
        
        let nextButton = Publishers.Merge4(all, age, service, personal)
            .compactMap { [weak self] _ in
                guard let self else {
                    return false
                }
                
                return self.buttonStates.ageAgree && self.buttonStates.service && self.buttonStates.personal
            }.eraseToAnyPublisher()
        
        let isAllAgreeOn = Publishers.Merge5(all, age, service, personal, advertise)
            .compactMap { [weak self] _ in
                guard let self else {
                    return false
                }
                
                return self.buttonStates.ageAgree && self.buttonStates.service && self.buttonStates.personal &&
                    self.buttonStates.advertise
            }.eraseToAnyPublisher()
        
        return TermsOfServiceOutput(isAllAgreeOn: isAllAgreeOn, isNextButtonOn: nextButton, states: state)
    }
}
