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
    var advertise: Bool = false
}

class TermsAgreeViewModel {
    var buttonStates = TermsButtonStates()
    var termsUseCase: TermsAgreeUseCase?
    let goToNext = PassthroughSubject<Void, Error>()
    
    struct TermsAgreeInput {
        let allAgree: AnyPublisher<Void, Never>
        let ageAgree: AnyPublisher<Void, Never>
        let service: AnyPublisher<Void, Never>
        let personal: AnyPublisher<Void, Never>
        let advertise: AnyPublisher<Void, Never>
        let next: AnyPublisher<Void, Never>
        let back: AnyPublisher<Void, Never>
    }
    
    struct TermsAgreeOutput {
        let isAllAgreeOn: AnyPublisher<Bool, Never>
        let isNextButtonOn: AnyPublisher<Bool, Never>
        let states: AnyPublisher<TermsButtonStates, Never>
        let goToNext: AnyPublisher<Void, Error>
        let handleBackButton: AnyPublisher<Void, Never>
    }
    
    struct DetailInput {
        let service: AnyPublisher<Void, Never>
        let personal: AnyPublisher<Void, Never>
        let advertise: AnyPublisher<Void, Never>
    }
    
    struct DetailOutput {
        let handleService: AnyPublisher<Void, Never>
        let handlePersonal: AnyPublisher<Void, Never>
        let handleAdvertise: AnyPublisher<Void, Never>
    }

    var detailState: TermsDetailStates?
    let handleDetail = PassthroughSubject<Void, Never>()
    
    init(termsUseCase: TermsAgreeUseCase?) {
        self.termsUseCase = termsUseCase
    }
    
    func transform(_ input: TermsAgreeInput) -> TermsAgreeOutput {
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
        
        let mainService = input.service
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.buttonStates.service.toggle()
            })
            .share()
        
        let detailService = handleDetail
            .map { [weak self] _ in
                self?.detailState == .service
            }
            .compactMap { [weak self] state in
                if state {
                    self?.buttonStates.service = true
                }
            }
            .eraseToAnyPublisher()
        
        let service = Publishers.Merge(mainService, detailService)
        
        let mainPersonal = input.personal
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.buttonStates.personal.toggle()
            })
            .share()
        
        let detailPersonal = handleDetail
            .map { [weak self] in
                self?.detailState == .personal
            }
            .compactMap { [weak self] state in
                if state {
                    self?.buttonStates.personal = true
                }
            }
            .eraseToAnyPublisher()
        
        let personal = Publishers.Merge(mainPersonal, detailPersonal)
    
        let mainAdvertise = input.advertise
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.buttonStates.advertise.toggle()
            }).share()
        
        let detailAdvertise = handleDetail
            .map { [weak self] _ in
                self?.detailState == .advertise
            }
            .compactMap { [weak self] state in
                if state {
                    self?.buttonStates.advertise = true
                }
            }
            .eraseToAnyPublisher()
        
        let advertise = Publishers.Merge(mainAdvertise, detailAdvertise)
        
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
        
        let goNext = input.next
            .map { [weak self] in
                self?.pushedNextButton()
            }
            .compactMap { [weak self] _ in
                self
            }
            .flatMap{ owner in
                owner.goToNext
            }
            .eraseToAnyPublisher()
            
        let back = input.back
            .eraseToAnyPublisher()
        
        return TermsAgreeOutput(isAllAgreeOn: isAllAgreeOn, isNextButtonOn: nextButton, states: state, goToNext: goNext, handleBackButton: back)
    }
    
    func transformDetail(_ input: DetailInput) -> DetailOutput {
        let service = input.service
            .compactMap { [weak self] _ in
                self?.detailState = .service
            }.eraseToAnyPublisher()
        
        let personal = input.personal
            .compactMap { [weak self] _ in
                self?.detailState = .personal
            }.eraseToAnyPublisher()
        
        let advertise = input.advertise
            .compactMap { [weak self] _ in
                self?.detailState = .advertise
            }.eraseToAnyPublisher()
        
        return DetailOutput(handleService: service, handlePersonal: personal, handleAdvertise: advertise)
    }
}

extension TermsAgreeViewModel {
    func pushedNextButton() {
        Task {
            do {
                try await termsUseCase?.termsWithAPI(states: buttonStates)
                goToNext.send()
            } catch {
                goToNext.send(completion: .failure(error))
            }
        }
    }
}
