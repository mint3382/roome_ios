//
//  ProfileViewModel.swift
//  roome
//
//  Created by minsong kim on 6/3/24.
//

import UIKit
import Combine

class ProfileCardViewModel {
    struct Input {
        let tapSquareButton = PassthroughSubject<Void, Never>()
        let tapRectangleButton = PassthroughSubject<Void, Never>()
        let tapSaveButton = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let handleSaveButton = PassthroughSubject<UIImage?, Never>()
        let handleSquareButton = PassthroughSubject<Bool, Never>()
    }
    
    let input: Input
    let output: Output
    
    private var cancellables = Set<AnyCancellable>()
    var isSquareSize: Bool = true
    
    init() {
        self.input = Input()
        self.output = Output()
        settingBind()
    }
    
    private func settingBind() {
        input.tapSaveButton
            .sink { [weak self] isSquare in
                guard let self else {
                    return
                }
                let image = self.checkProfileCard()
                self.output.handleSaveButton.send(image)
            }
            .store(in: &cancellables)
        
        input.tapSquareButton
            .sink { [weak self] in
                self?.isSquareSize = true
                self?.output.handleSquareButton.send(true)
            }
            .store(in: &cancellables)
        
        input.tapRectangleButton
            .sink { [weak self] in
                self?.isSquareSize = false
                self?.output.handleSquareButton.send(false)
            }
            .store(in: &cancellables)
    }
    
    private func checkProfileCard() -> UIImage? {
        var image: UIImage?
        
        if isSquareSize {
            image = ImageManager.loadImageFromDirectory(identifier: .squareCard)
        } else {
            image = ImageManager.loadImageFromDirectory(identifier: .rectangleCard)
        }
        
        return image
    }
}

