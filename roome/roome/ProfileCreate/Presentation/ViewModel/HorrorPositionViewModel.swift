//
//  HorrorPositionViewModel.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import Foundation
import Combine

class HorrorPositionViewModel {
    struct Input {
        let tapBackButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let handleCellSelect: AnyPublisher<IndexPath, Never>
        let handleBackButton: AnyPublisher<Void, Never>
    }
    
    var selectCell = PassthroughSubject<IndexPath, Never>()
    private var goToNext = PassthroughSubject<Int,Never>()
    
    func transform(_ input: Input) -> Output {
        let cellSelect = selectCell
            .eraseToAnyPublisher()
        
        let back = input.tapBackButton
            .eraseToAnyPublisher()
        
        return Output(handleCellSelect: cellSelect,
                      handleBackButton: back)
    }
}

