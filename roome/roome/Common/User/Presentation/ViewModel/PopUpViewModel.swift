//
//  PopUpViewModel.swift
//  roome
//
//  Created by minsong kim on 5/31/24.
//

import Foundation
import Combine

class PopUpViewModel {
    struct Input {
        let newButton: AnyPublisher<Void, Never>
        let stillButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let handleNext: AnyPublisher<StateDTO, Never>
    }
    
    func transforms(_ input: Input) -> Output {
        let new = input.newButton
            .map {
                //TODO: - 기존 프로필 삭제
                StateDTO.roomCount
            }.eraseToAnyPublisher()
        
        let still = input.stillButton
            .compactMap {
                StateDTO(rawValue: UserContainer.shared.profile!.data.state)
            }.eraseToAnyPublisher()
        
        let next = Publishers.Merge(new, still)
            .eraseToAnyPublisher()
        
        return Output(handleNext: next)
    }
}
