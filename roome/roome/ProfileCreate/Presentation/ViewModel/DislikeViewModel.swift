//
//  DislikeViewModel.swift
//  roome
//
//  Created by minsong kim on 5/24/24.
//

import Foundation
import Combine

class DislikeViewModel {
    struct Input {
        let tapNextButton: AnyPublisher<Void, Never>
        let tapBackButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let handleCellSelect: AnyPublisher<(Bool, IndexPath), Never>
        let handleNextButton: AnyPublisher<Void, Never>
        let canGoNext: AnyPublisher<Bool, Never>
        let handleBackButton: AnyPublisher<Void, Never>
    }
    
    var selectCell = PassthroughSubject<IndexPath, Never>()
    var deselectCell = PassthroughSubject<IndexPath, Never>()
    private var goToNext = PassthroughSubject<Int,Never>()
    var list = Set<IndexPath>()
    
    func transform(_ input: Input) -> Output {
        let handleCellSelect = selectCell
            .compactMap {
                $0
            }
            .compactMap { [weak self] item in
                self?.canSelectCount(item)
            }
            .eraseToAnyPublisher()
        
        let cellSelect = Publishers.Zip(handleCellSelect, deselectCell)
            .eraseToAnyPublisher()
        
        let canGoNext = goToNext
            .map { count in
                0 < count && count <= 2
            }.eraseToAnyPublisher()
        
        let handleNextButton = input.tapNextButton
            .eraseToAnyPublisher()
        
        let back = input.tapBackButton
            .eraseToAnyPublisher()
        
        return Output(handleCellSelect: cellSelect,
                      handleNextButton: handleNextButton,
                      canGoNext: canGoNext,
                      handleBackButton: back)
    }
    
    func deselectItem(_ item: IndexPath) {
        if list.contains(item) {
            list.remove(item)
            goToNext.send(list.count)
        }
    }
    
    func canSelectCount(_ item: IndexPath) -> Bool? {
        deselectCell.send(item)
        print(ProfileModel.dislike[item.item])
        if list.count < 2 {
            list.insert(item)
            goToNext.send(list.count)
            return true
        } else {
            return false
        }
    }
}
