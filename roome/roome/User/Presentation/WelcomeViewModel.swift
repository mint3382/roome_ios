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
        let handleNext: AnyPublisher<Void, Never>
    }
    
    func transforms(_ input: Input) -> Output {
        let next = input.nextButton
            .eraseToAnyPublisher()
        
        return Output(handleNext: next)
    }
}
