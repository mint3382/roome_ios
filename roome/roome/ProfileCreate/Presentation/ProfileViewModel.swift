//
//  ProfileViewModel.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import Foundation
import Combine

class ProfileViewModel {
    struct Input {
        let tapBackButton: AnyPublisher<Void, Never>
        let tapSquareButton: AnyPublisher<Void, Never>
        let tapRectangleButton: AnyPublisher<Void, Never>
        let tapSaveButton: AnyPublisher<Void, Never>
        let tapNextButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let handleSquareButton: AnyPublisher<Void, Never>
        let handleRectangleButton: AnyPublisher<Void, Never>
        let handleSaveButton: AnyPublisher<Void, Never>
        let handleNextButton: AnyPublisher<Void, Never>
        let handleBackButton: AnyPublisher<Void, Never>
    }
    
    func transform(_ input: Input) -> Output {
        let back = input.tapBackButton
            .eraseToAnyPublisher()
        
        let square = input.tapSquareButton
            .eraseToAnyPublisher()
        
        let rectangle = input.tapRectangleButton
            .eraseToAnyPublisher()
        
        let save = input.tapSaveButton
            .eraseToAnyPublisher()
        
        let next = input.tapNextButton
            .eraseToAnyPublisher()
        
        
        return Output(handleSquareButton: square,
                      handleRectangleButton: rectangle,
                      handleSaveButton: save,
                      handleNextButton: next,
                      handleBackButton: back)
    }
}

