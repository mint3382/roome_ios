//
//  TermsOfServiceViewController.swift
//  roome
//
//  Created by minsong kim on 5/19/24.
//

import UIKit
import Combine

class TermsAgreeViewController: UIViewController {
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
        label.font = .boldHeadline2
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
        button.titleLabel?.font = .regularBody2
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let ageAgreeButton: LabelButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .label
        configuration.image = UIImage(systemName: "checkmark")?.changeImageColor( .lightGray).resize(newWidth: 12)
        configuration.imagePadding = 12
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        configuration.title = "만 14세 이상입니다.(필수)"
        
        let button = LabelButton(frame: .zero, isDetailButton: false)
        button.setMain(config: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let serviceAgreeButton: LabelButton = {
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
    
    private let personalInformationAgreeButton: LabelButton = {
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
    
    private let advertiseAgreeButton: LabelButton = {
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
    
    private let nextButton = NextButton()
    private let backButton = BackButton()
    
    let viewModel: TermsAgreeViewModel
    var cancellable = Set<AnyCancellable>()
    
    init(viewModel: TermsAgreeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureStackView()
        configureNextButton()
        bind()
    }
    
    func bind() {
        let all = allAgreeButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        let age = ageAgreeButton.tappedMainButtonPublisher()
        let service = serviceAgreeButton.tappedMainButtonPublisher()
        let personal = personalInformationAgreeButton.tappedMainButtonPublisher()
        let advertise = advertiseAgreeButton.tappedMainButtonPublisher()
        let next = nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        let back = backButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        
        let output = viewModel.transform(TermsAgreeViewModel.TermsAgreeInput(allAgree: all,ageAgree: age, service: service, personal: personal, advertise: advertise, next: next, back: back))
        
        output.states
            .sink { [weak self] states in
                if states.ageAgree {
                    self?.ageAgreeButton.updateImageColor(.roomeMain)
                } else {
                    self?.ageAgreeButton.updateImageColor(.lightGray)
                }
                
                if states.service {
                    self?.serviceAgreeButton.updateImageColor(.roomeMain)
                } else {
                    self?.serviceAgreeButton.updateImageColor(.lightGray)
                }
                
                if states.personal {
                    self?.personalInformationAgreeButton.updateImageColor(.roomeMain)
                } else {
                    self?.personalInformationAgreeButton.updateImageColor(.lightGray)
                }
                
                if states.advertise {
                    self?.advertiseAgreeButton.updateImageColor(.roomeMain)
                } else {
                    self?.advertiseAgreeButton.updateImageColor(.lightGray)
                }
            }.store(in: &cancellable)
        
        output.isNextButtonOn
            .sink { [weak self] isEnable in
                if isEnable {
                    self?.nextButton.isEnabled = true
                    self?.nextButton.backgroundColor = .roomeMain
                } else {
                    self?.nextButton.isEnabled = false
                    self?.nextButton.backgroundColor = .gray
                }
            }.store(in: &cancellable)
        
        output.isAllAgreeOn
            .sink { [weak self] isSelected in
                if isSelected {
                    self?.allAgreeButton.configuration?.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.roomeMain).resize(newWidth: 24)
                } else {
                    self?.allAgreeButton.configuration?.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.lightGray).resize(newWidth: 24)
                }
            }.store(in: &cancellable)
        
        output.goToNext
            .sink { _ in
                let next = DIContainer.shared.resolve(LoginViewController.self)
                Task { @MainActor in
                    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.dismiss(animated: false)
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                        .changeRootViewController(next, animated: true)
                }
            } receiveValue: { [weak self] _ in
                Task { @MainActor in
                    let nextPage = DIContainer.shared.resolve(NicknameViewController.self)
                    self?.navigationController?.pushViewController(nextPage, animated: true)
                }
            }
            .store(in: &cancellable)

        output.handleBackButton
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellable)
    }
    
    private func configureStackView() {
        view.addSubview(backButton)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(allAgreeButton)
        stackView.addArrangedSubview(ageAgreeButton)
        stackView.addArrangedSubview(serviceAgreeButton)
        stackView.addArrangedSubview(personalInformationAgreeButton)
        stackView.addArrangedSubview(advertiseAgreeButton)
        
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            
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
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
