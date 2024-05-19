//
//  LabelButton.swift
//  roome
//
//  Created by minsong kim on 5/19/24.
//

import UIKit
import Combine

class LabelButton: UIView {
    private let mainButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.font = UIFont().pretendardMedium(size: .label)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    private let detailButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.right")?.resize(newWidth: 12).changeImageColor(.systemGray4)
        configuration.imagePadding = 12
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 20)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var isDetailButton: Bool
    
    init(frame: CGRect, isDetailButton: Bool) {
        self.isDetailButton = isDetailButton
        super.init(frame: .zero)
        
        if isDetailButton {
            setDetail()
        } else {
            setMain()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tappedMainButtonPublisher() -> AnyPublisher<Void, Never> {
        mainButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
    }
    
    func setMain(config: UIButton.Configuration) {
        mainButton.configuration = config
        mainButton.titleLabel?.font = UIFont().pretendardMedium(size: .label)
    }
    
    func updateImageColor(_ color: UIColor) {
        mainButton.configuration?.image = UIImage(systemName: "checkmark")?.resize(newWidth: 16).changeImageColor(color)
    }
    
    func setDetail() {
        self.addSubview(mainButton)
        self.addSubview(detailButton)
        
        NSLayoutConstraint.activate([
            detailButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            detailButton.topAnchor.constraint(equalTo: self.topAnchor),
            detailButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            mainButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainButton.topAnchor.constraint(equalTo: self.topAnchor),
            mainButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainButton.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor),
        ])
        mainButton.setContentHuggingPriority(.init(100), for: .horizontal)
    }
    
    func setMain() {
        self.addSubview(mainButton)
        
        NSLayoutConstraint.activate([
            mainButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainButton.topAnchor.constraint(equalTo: self.topAnchor),
            mainButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
