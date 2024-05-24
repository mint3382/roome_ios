//
//  MBTIViewModel.swift
//  roome
//
//  Created by minsong kim on 5/23/24.
//

import Foundation
import Combine

class MBTIViewModel {
    struct Input {
        let tapNextButton: AnyPublisher<Void, Never>
        let tapBackButton: AnyPublisher<Void, Never>
        let tapWillNotAddButton: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let handleCellSelect: AnyPublisher<(Bool, IndexPath), Never>
        let handleNextButton: AnyPublisher<Void, Never>
        let canGoNext: AnyPublisher<Bool, Never>
        let handleBackButton: AnyPublisher<Void, Never>
        let handleWillNotAddButton: AnyPublisher<Bool, Never>
    }
    
    var selectCell = PassthroughSubject<IndexPath, Never>()
    var deselectCell = PassthroughSubject<IndexPath, Never>()
    private var goToNext = PassthroughSubject<Int,Never>()
    private var withoutButtonState = false
    var list = Set<Int>()
    
    func transform(_ input: Input) -> Output {
        let handleCellSelect = selectCell
            .compactMap {
                $0
            }
            .compactMap { [weak self] item in
                self?.canSelect(item)
            }
            .eraseToAnyPublisher()
        
        let cellSelect = Publishers.Zip(handleCellSelect, deselectCell)
            .eraseToAnyPublisher()
        
        let canGoNext = goToNext
            .map { count in
                count == 4
            }.eraseToAnyPublisher()
        
        let handleWithoutButton = input.tapWillNotAddButton
            .map { [weak self] _ in
                self?.withoutButtonState.toggle()
                self?.list = []
            }
            .compactMap { [weak self] _ in
                self?.isWithoutButtonSelect()
            }
            .eraseToAnyPublisher()
        
        let handleNextButton = input.tapNextButton
            .eraseToAnyPublisher()
        
        let back = input.tapBackButton
            .eraseToAnyPublisher()
        
        return Output(handleCellSelect: cellSelect, handleNextButton: handleNextButton, canGoNext: canGoNext, handleBackButton: back, handleWillNotAddButton: handleWithoutButton)
    }
    
    func isWithoutButtonSelect() -> Bool {
        if withoutButtonState {
            goToNext.send(4)
            return true
        } else {
            goToNext.send(0)
            return false
        }
    }
    
    func deselectItem(_ item: IndexPath) {
        if list.contains(item.item / 2) {
            list.remove(item.item / 2)
            goToNext.send(list.count)
        }
    }
    
    func canSelect(_ item: IndexPath) -> Bool {
        deselectCell.send(item)
        print(ProfileModel.genre[item.item])
        //있는지 없는지 체크
        if list.contains(item.item / 2) {
            return false
        } else {
            list.insert(item.item / 2)
            goToNext.send(list.count)
            return true
        }
    }
}
