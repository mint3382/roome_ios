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
        let tapOkayButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let handleSquareButton: AnyPublisher<Void, Never>
        let handleRectangleButton: AnyPublisher<Void, Never>
        let handleSaveButton: AnyPublisher<Bool, Never>
        let handleNextButton: AnyPublisher<Void, Never>
        let handleBackButton: AnyPublisher<Void, Never>
        let handleOkayButton: AnyPublisher<Void, Never>
    }
    
    var isSquareSize: Bool = true
    
    func transform(_ input: Input) -> Output {
        let back = input.tapBackButton
            .eraseToAnyPublisher()
        
        let square = input.tapSquareButton
            .compactMap { [weak self] _ in
                self?.isSquareSize = true
            }
            .eraseToAnyPublisher()
        
        let rectangle = input.tapRectangleButton
            .compactMap { [weak self] _ in
                self?.isSquareSize = false
            }
            .eraseToAnyPublisher()
        
        let save = input.tapSaveButton
            .compactMap { [weak self] _ in
                self?.isSquareSize
            }
            .eraseToAnyPublisher()
        
        let next = input.tapNextButton
            .eraseToAnyPublisher()
        
        let okay = input.tapOkayButton
            .eraseToAnyPublisher()
        
        
        return Output(handleSquareButton: square,
                      handleRectangleButton: rectangle,
                      handleSaveButton: save,
                      handleNextButton: next,
                      handleBackButton: back,
                      handleOkayButton: okay)
    }
}

