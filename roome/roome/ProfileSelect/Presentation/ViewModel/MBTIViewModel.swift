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
        let cellSelect = PassthroughSubject<IndexPath, Never>()
        let cellDeselect = PassthroughSubject<IndexPath, Never>()
        let tappedNotAddButton = PassthroughSubject<Void, Never>()
        let tappedNextButton = PassthroughSubject<Void, Never>()
        let tappedCloseButton = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let deselectCell = PassthroughSubject<IndexPath, Never>()
        let canGoNext = PassthroughSubject<Bool, Never>()
        let handleNotAddButton = PassthroughSubject<Bool, Never>()
        let handleNextButton = PassthroughSubject<Result<Void, Error>, Never>()
        let handleCloseButton = PassthroughSubject<Bool, Never>()
    }
    
    let input: Input
    let output: Output
    
    private var cancellables = Set<AnyCancellable>()
    
    var withoutButtonState = false
    private var list: [Int: Int] = [0: -1, 1: -1, 2: -1, 3: -1]
    private var count: Int = 0
    private var useCase: ProfileSelectUseCaseType
    
    init(useCase: ProfileSelectUseCaseType) {
        self.useCase = useCase
        self.input = Input()
        self.output = Output()
        settingBind()
    }
    
    func settingBind() {
        input.cellSelect
            .sink { [weak self] indexPath in
                self?.canSelect(indexPath)
            }
            .store(in: &cancellables)
        
        input.tappedNotAddButton
            .sink { [weak self] in
                guard let self else {
                    return
                }
                withoutButtonState.toggle()
                list = [0: -1, 1: -1, 2: -1, 3: -1]
                count = 0
                
                output.canGoNext.send(withoutButtonState)
                output.handleNotAddButton.send(withoutButtonState)
            }
            .store(in: &cancellables)
        
        input.tappedNextButton
            .sink { [weak self]  in
                self?.handlePage()
            }
            .store(in: &cancellables)
        
        input.cellDeselect
            .sink { [weak self] indexPath in
                self?.deselectItem(indexPath)
            }
            .store(in: &cancellables)
        
        input.tappedCloseButton
            .sink { [weak self] in
                self?.checkEdit()
            }
            .store(in: &cancellables)
    }
    
    private func checkEdit() {
        var mbtis: [String] = []
        
        mbtis.append(MBTIDTO.EI(rawValue: list[0] ?? -1)?.title ?? "N")
        mbtis.append(MBTIDTO.NS(rawValue: list[1] ?? -1)?.title ?? "O")
        mbtis.append(MBTIDTO.TF(rawValue: list[2] ?? -1)?.title ?? "N")
        mbtis.append(MBTIDTO.JP(rawValue: list[3] ?? -1)?.title ?? "E")
        
        let mbti = mbtis.joined()
        let userMbti = UserContainer.shared.profile?.data.mbti
        
        if userMbti == mbti {
            output.handleCloseButton.send(false)
        } else {
            output.handleCloseButton.send(true)
        }
    }
    
    //deselect시 체크
    func deselectItem(_ item: IndexPath) {
        if list[item.section] != -1 {
            list[item.section] = -1
            count -= 1
        }
        
        if count == 4 {
            output.canGoNext.send(true)
        } else {
            output.canGoNext.send(false)
        }
    }
    
    //선택시 체크
    func canSelect(_ item: IndexPath) {
        //있는지 없는지 체크
        if list[item.section] != -1 {
            output.deselectCell.send(IndexPath(row: list[item.section] ?? 0, section: item.section)) //기존 cell deselect
            list[item.section] = item.row
        } else {
            list[item.section] = item.row
            count += 1
        }
        
        if count == 4 {
            output.canGoNext.send(true)
        } else {
            output.canGoNext.send(false)
        }
        
        self.withoutButtonState = false
        output.handleNotAddButton.send(withoutButtonState)
    }
    
    //다음 페이지로
    func handlePage() {
        Task {
            do {
                var mbtis: [String] = []
                
                mbtis.append(MBTIDTO.EI(rawValue: list[0] ?? -1)?.title ?? "N")
                mbtis.append(MBTIDTO.NS(rawValue: list[1] ?? -1)?.title ?? "O")
                mbtis.append(MBTIDTO.TF(rawValue: list[2] ?? -1)?.title ?? "N")
                mbtis.append(MBTIDTO.JP(rawValue: list[3] ?? -1)?.title ?? "E")
                
                try await useCase.mbtiWithAPI(mbti: mbtis)
                try await UserContainer.shared.updateUserProfile()
                output.handleNextButton.send(.success({}()))
            } catch {
                output.handleNextButton.send(.failure(error))
            }
        }
    }
}
