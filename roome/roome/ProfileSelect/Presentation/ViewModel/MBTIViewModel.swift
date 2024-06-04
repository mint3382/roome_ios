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
        let handleNextButton: AnyPublisher<Void, Error>
        let tapNext: AnyPublisher<Void, Never>
        let canGoNext: AnyPublisher<Bool, Never>
        let handleBackButton: AnyPublisher<Void, Never>
        let handleWillNotAddButton: AnyPublisher<Bool, Never>
    }
    
    var selectCell = PassthroughSubject<IndexPath, Never>()
    var deselectCell = PassthroughSubject<IndexPath, Never>()
    private var canGoNext = PassthroughSubject<Int,Never>()
    private var goToNext = PassthroughSubject<Void,Error>()
    private var withoutButtonState = false
    private var list: [Int: Int] = [0: -1, 1: -1, 2: -1, 3: -1]
    private var count: Int = 0
    private var useCase: MbtiUseCase
    
    init(useCase: MbtiUseCase) {
        self.useCase = useCase
    }
    
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
        
        let canGoNext = canGoNext
            .map { count in
                count == 4
            }.eraseToAnyPublisher()
        
        let handleWithoutButton = input.tapWillNotAddButton
            .map { [weak self] _ in
                self?.withoutButtonState.toggle()
                self?.list = [0: -1, 1: -1, 2: -1, 3: -1]
                self?.count = 0
            }
            .compactMap { [weak self] _ in
                self?.isWithoutButtonSelect()
            }
            .eraseToAnyPublisher()
        
        let tapNext = input.tapNextButton
            .compactMap { [weak self] _ in
                self?.handlePage()
            }
            .eraseToAnyPublisher()
        
        let handleNextButton = goToNext
            .eraseToAnyPublisher()
        
        let back = input.tapBackButton
            .eraseToAnyPublisher()
        
        return Output(handleCellSelect: cellSelect, handleNextButton: handleNextButton, tapNext: tapNext, canGoNext: canGoNext, handleBackButton: back, handleWillNotAddButton: handleWithoutButton)
    }
    
    func isWithoutButtonSelect() -> Bool {
        if withoutButtonState {
            canGoNext.send(4)
            return true
        } else {
            canGoNext.send(0)
            return false
        }
    }
    
    func deselectItem(_ item: IndexPath) {
        if list[item.item / 2] != -1 {
            list[item.item / 2] = -1
            count -= 1
            canGoNext.send(count)
        }
    }
    
    func canSelect(_ item: IndexPath) -> Bool {
        deselectCell.send(item)
        //있는지 없는지 체크
        if list[item.item / 2] != -1 {
            return false
        } else {
            list[item.item / 2] = item.row
            count += 1
            canGoNext.send(count)
            return true
        }
    }
    
    //다음 페이지로
    func handlePage() {
        Task {
            do {
                var mbtis: [String] = []
                for item in (list.sorted{ $0.0 < $1.0})  {
                    guard item.value != -1 else {
                        mbtis = ["NONE"]
                        break
                    }
                    mbtis.append(MBTIDTO(rawValue: item.value)!.title)
                }
                try await useCase.mbtiWithAPI(mbti: mbtis)
                goToNext.send()
            } catch {
                goToNext.send(completion: .failure(error))
            }
        }
    }
}
