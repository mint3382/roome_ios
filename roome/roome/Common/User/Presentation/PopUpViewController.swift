//
//  PopUpViewController.swift
//  roome
//
//  Created by minsong kim on 5/31/24.
//

import UIKit

class PopUpViewController: UIViewController {
    private let popUpView: PopUpView = {
        let view = PopUpView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        self.view.isOpaque = false
        self.view.addSubview(popUpView)
        configurePopUpView()
    }
    
    func configurePopUpView() {
        NSLayoutConstraint.activate([
            popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popUpView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            popUpView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            popUpView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.24)
        ])
    }
}

class PopUpView: UIView {
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 20
        
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제작 중인 프로필이 있어요"
        label.textColor = .black
        label.font = UIFont().pretendardBold(size: .title1)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "이어서 만드시겠어요?"
        label.textColor = .black
        label.font = UIFont().pretendardRegular(size: .label)
        
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 4
        
        return stack
    }()
    
    let firstButton: UIButton = {
        var configuration = UIButton.Configuration.borderedTinted()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont().pretendardBold(size: .label)
        configuration.attributedTitle = AttributedString("처음부터 하기", attributes: titleContainer)
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
    
    let stillMakingButton: UIButton = {
        var configuration = UIButton.Configuration.borderedTinted()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont().pretendardBold(size: .label)
        configuration.attributedTitle = AttributedString("이어서 하기", attributes: titleContainer)
        configuration.baseBackgroundColor = .roomeMain
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30)
        let button = UIButton(configuration: configuration)
        button.backgroundColor = .roomeMain
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.roomeMain.cgColor
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureButton()
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStackView() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func configureButton() {
        buttonStackView.addArrangedSubview(firstButton)
        buttonStackView.addArrangedSubview(stillMakingButton)
        
        NSLayoutConstraint.activate([
            buttonStackView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}
