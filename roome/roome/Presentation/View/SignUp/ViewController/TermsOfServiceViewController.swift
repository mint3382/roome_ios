//
//  TermsOfServiceViewController.swift
//  roome
//
//  Created by minsong kim on 5/19/24.
//

import UIKit

class TermsOfServiceViewController: UIViewController {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 12
        
        return stack
    }()
    
    private let titleLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "서비스 이용약관"
        label.numberOfLines = 2
        label.sizeToFit()
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont().pretendardBold(size: .headline2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let allAgreeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .label
        configuration.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.lightGray).resize(newWidth: 24)
        configuration.imagePadding = 8
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 10, trailing: 20)
        configuration.title = "모두 동의(선택 정보 포함)"
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = UIFont().pretendardMedium(size: .label)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let ageAgreeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .label
        configuration.image = UIImage(systemName: "checkmark")?.changeImageColor( .lightGray).resize(newWidth: 12)
        configuration.imagePadding = 12
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        configuration.title = "만 14세 이상입니다.(필수)"
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = UIFont().pretendardMedium(size: .label)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let serviceAgreeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .label
        configuration.image = UIImage(systemName: "checkmark")?.changeImageColor( .lightGray).resize(newWidth: 12)
        configuration.imagePadding = 12
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        configuration.title = "서비스 이용약관에 동의 (필수)"
        
        let button = LabelButton(frame: .zero, isDetailButton: true)
        button.setMain(config: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let personalInformationAgreeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .label
        configuration.image = UIImage(systemName: "checkmark")?.changeImageColor( .lightGray).resize(newWidth: 12)
        configuration.imagePadding = 12
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        configuration.title = "개인정보 수집 및 이용약관에 동의 (필수)"
        
        let button = LabelButton(frame: .zero, isDetailButton: true)
        button.setMain(config: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let advertiseAgreeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .label
        configuration.image = UIImage(systemName: "checkmark")?.changeImageColor( .lightGray).resize(newWidth: 12)
        configuration.imagePadding = 12
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        configuration.title = "광고 및 마케팅 수신에 동의 (선택)"
        
        let button = LabelButton(frame: .zero, isDetailButton: true)
        button.setMain(config: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .gray
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont().pretendardBold(size: .label)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        configureNextButton()
    }
    
    private func configureStackView() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(allAgreeButton)
        stackView.addArrangedSubview(ageAgreeButton)
        stackView.addArrangedSubview(serviceAgreeButton)
        stackView.addArrangedSubview(personalInformationAgreeButton)
        stackView.addArrangedSubview(advertiseAgreeButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            serviceAgreeButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            serviceAgreeButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            personalInformationAgreeButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            personalInformationAgreeButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            advertiseAgreeButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            advertiseAgreeButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
        ])
    }

    private func configureNextButton() {
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
