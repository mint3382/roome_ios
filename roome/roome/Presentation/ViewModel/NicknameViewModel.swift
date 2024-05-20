//
//  NicknameViewModel.swift
//  roome
//
//  Created by minsong kim on 5/17/24.
//

import UIKit
import Combine

class NicknameViewModel {
    struct NicknameViewModelInput {
//        var pushedNextButton = PassthroughSubject<Void, Never>() //나중에 서버랑 연결
        var nickname: AnyPublisher<String, Never>
    }

    struct NicknameViewModelOutput {
        var isButtonEnable: AnyPublisher<Bool, Never>
    }
    
    //비즈니스 로직 담당하는 UseCase - domain
    private let usecase: NicknameUseCase
    
    init(usecase: NicknameUseCase) {
        self.usecase = usecase
    }
    
    func transform(_ input: NicknameViewModelInput) -> NicknameViewModelOutput {
        //input을 output으로
        let isButtonEnable = input.nickname
            .compactMap { $0 }
            .compactMap { [weak self] in
                self?.usecase.checkNicknameCount($0)
            }.eraseToAnyPublisher()
        
        return NicknameViewModelOutput(isButtonEnable: isButtonEnable)
    }
    
    func canFillTextField(_ text: String) -> Bool {
        usecase.checkNicknameText(text)
    }
}
