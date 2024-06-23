//
//  PopUpView.swift
//  roome
//
//  Created by minsong kim on 5/31/24.
//

import UIKit
import Combine

class PopUpView: UIView {
    private let boxView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = true
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 32
        
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제작 중인 프로필이 있어요"
        label.textColor = .black
        label.font = .boldTitle1
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "이어서 만드시겠어요?"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .regularBody2
        label.numberOfLines = 0
        
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = true
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 4
        
        return stack
    }()
    
    private let whiteButton: UIButton = {
        var configuration = UIButton.Configuration.borderedTinted()
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 24, bottom: 30, trailing: 24)
        let button = UIButton(configuration: configuration)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        
        return button
    }()
    
    private let colorButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .roomeMain
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30)
        let button = UIButton(configuration: configuration)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        configureStackView()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, title: String, description: String, whiteButtonTitle: String? = nil, colorButtonTitle: String) {
        self.init(frame: frame)
        titleLabel.text = title
        descriptionLabel.text = description
        var titleContainer = AttributeContainer()
        titleContainer.font = .boldTitle3
        
        if let whiteButtonTitle {
            configureWhiteButton()
            whiteButton.configuration?.attributedTitle = AttributedString(whiteButtonTitle, attributes: titleContainer)
            colorButton.configuration?.attributedTitle = AttributedString(colorButtonTitle, attributes: titleContainer)
        } else {
            buttonStackView.addArrangedSubview(colorButton)
            colorButton.configuration?.attributedTitle = AttributedString(colorButtonTitle, attributes: titleContainer)
        }
    }
    
    func publisherColorButton() -> AnyPublisher<Void, Never> {
        colorButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    func publisherWhiteButton() -> AnyPublisher<Void, Never> {
        whiteButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    private func configureStackView() {
        self.addSubview(boxView)
        boxView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            boxView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            boxView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            boxView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            boxView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.55),
            
            stackView.centerYAnchor.constraint(equalTo: boxView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: boxView.centerXAnchor)
        ])
    }
    
    private func configureButton() {
        NSLayoutConstraint.activate([
            buttonStackView.heightAnchor.constraint(equalToConstant: 45),
            buttonStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func configureWhiteButton() {
        buttonStackView.addArrangedSubview(whiteButton)
        buttonStackView.addArrangedSubview(colorButton)
        
        NSLayoutConstraint.activate([
            whiteButton.heightAnchor.constraint(equalToConstant: 45),
            whiteButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.38),
            colorButton.heightAnchor.constraint(equalToConstant: 45),
            colorButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.38)
        ])
    }
}
