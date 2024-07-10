//
//  RoomCountViewModel.swift
//  roome
//
//  Created by minsong kim on 5/22/24.
//

import Foundation
import Combine

class RoomCountViewModel {
    struct Input1 {
        var count: AnyPublisher<String, Never>
        var nextButton: AnyPublisher<Void, Never>
        var rangeButton: AnyPublisher<Void, Never>
        var textButton: AnyPublisher<Void, Never>
    }
    
    struct Input {
        let count = PassthroughSubject<String, Never>()
        let tapNextButton = PassthroughSubject<Void, Never>()
        let tapRangeButton = PassthroughSubject<Void, Never>()
        let tapTextButton = PassthroughSubject<Void, Never>()
        let tapCloseButton = PassthroughSubject<Void, Never>()
    }
    
    struct Output1 {
        var handleNextButton: AnyPublisher<Bool, Never>
        var handleNextPage: AnyPublisher<Void, Error>
        var handleRangeOrText: AnyPublisher<Bool, Never>
        var tapNext: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let handleNextButton = PassthroughSubject<Result<Void, Error>, Never>()
        let handleCanGoNext = PassthroughSubject<Bool, Never>()
        let handleRangeOrText = PassthroughSubject<Bool, Never>()
        let handleCloseButton = PassthroughSubject<Bool, Never>()
    }
    
    private let usecase: ProfileSelectUseCaseType
    let input: Input
    let output: Output
    private var cancellables = Set<AnyCancellable>()
//    private let goToNext = PassthroughSubject<Void, Error>()
    @Published var textInput: String = "0"
//    {
//        if let count = UserContainer.shared.profile?.data.count, count.contains("~") == false {
//            return count
//        } else {
//            return "0"
//        }
//    }()
    private var isRangeState: Bool = true
    var isSelected: (min: Int, max: Int) = (0,0)
//    {
//        if let count = UserContainer.shared.profile?.data.count, count.contains("~") == false {
//            let range = count.split(separator: "~").compactMap { Int($0) }
//            return (range[0], range[1])
//        } else {
//            return (0,0)
//        }
//    }()
    
    init(usecase: ProfileSelectUseCaseType) {
        self.usecase = usecase
        self.input = Input()
        self.output = Output()
        settingBind()
    }
    
    private func settingBind() {
        input.tapRangeButton
            .sink { [weak self] in
                guard let self else {
                    return
                }
                
                isRangeState = true
                if isSelected.max == 0 {
                    output.handleCanGoNext.send(false)
                } else {
                    output.handleCanGoNext.send(true)
                }
                
                output.handleRangeOrText.send(isRangeState)
            }
            .store(in: &cancellables)
        
        input.tapTextButton
            .sink { [weak self] in
                guard let self else {
                    return
                }
                
                isRangeState = false
                if textInput.count == 0 {
                    output.handleCanGoNext.send(false)
                } else {
                    output.handleCanGoNext.send(true)
                }
                
                output.handleRangeOrText.send(isRangeState)
            }
            .store(in: &cancellables)
        
        input.tapNextButton
            .sink { [weak self] in
                guard let self else {
                    return
                }
                
                if isRangeState {
                    handlePage(range: isSelected)
                } else {
                    handlePage(count: textInput)
                }
            }
            .store(in: &cancellables)
        
        input.tapCloseButton
            .sink { [weak self] in
                self?.checkEdit()
            }
            .store(in: &cancellables)
    }
    
    private func checkEdit() {
        let userRange = "\(isSelected.min)~\(isSelected.max)"
        let userCount = textInput
        let profileItem = UserContainer.shared.profile?.data.count
        
        if profileItem == userRange || profileItem == userCount {
            output.handleCloseButton.send(false)
        } else {
            output.handleCloseButton.send(true)
        }
    }
    
    private func handlePage(count: String?) {
        Task {
            do {
                try await usecase.roomCountWithAPI(count)
                try await UserContainer.shared.updateUserProfile()
                output.handleNextButton.send(.success({}()))
            } catch {
                output.handleNextButton.send(.failure(error))
            }
        }
    }
    
    private func handlePage(range: (min: Int, max: Int)) {
        Task {
            do {
                try await usecase.roomRangeWithAPI(range)
                try await UserContainer.shared.updateUserProfile()
                output.handleNextButton.send(.success({}()))
            } catch {
                output.handleNextButton.send(.failure(error))
            }
        }
    }
}
