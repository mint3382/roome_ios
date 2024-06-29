//
//  LabelButton.swift
//  roome
//
//  Created by minsong kim on 5/19/24.
//

import UIKit
import Combine

class LabelButton: UIView {
    private var mainButtonFont: UIFont
    
    private let mainButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 12
        configuration.imagePlacement = .leading
        configuration.baseForegroundColor = .label
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        
        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let detailButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.right")?.resize(newWidth: 12).changeImageColor(.systemGray4)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 20)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var isDetailButton: Bool
    
    init(frame: CGRect, isDetailButton: Bool, font: UIFont = .regularBody2) {
        self.isDetailButton = isDetailButton
        self.mainButtonFont = font
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if isDetailButton {
            configureDetail()
        } else {
            configureMain()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        mainButton.titleLabel?.font = mainButtonFont
    }

    func tappedMainButtonPublisher() -> AnyPublisher<Void, Never> {
        mainButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    func tappedDetailButtonPublisher() -> AnyPublisher<Void, Never> {
        detailButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    func updateMainButton(title: String, image: UIImage?, color: UIColor = .label, padding: CGFloat = 12) {
        mainButton.configuration?.title = title
        mainButton.configuration?.image = image
        mainButton.configuration?.baseForegroundColor = color
        mainButton.configuration?.imagePadding = padding
    }
    
    func updateDetailImage(_ image: UIImage?) {
        detailButton.configuration?.image = image
    }
    
    func updateImageColor(_ color: UIColor) {
        mainButton.configuration?.image = UIImage(systemName: "checkmark")?.changeImageColor(color).resize(newWidth: 12)
    }
    
    private func configureDetail() {
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
    
    private func configureMain() {
        self.addSubview(mainButton)
        
        NSLayoutConstraint.activate([
            mainButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainButton.topAnchor.constraint(equalTo: self.topAnchor),
            mainButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
