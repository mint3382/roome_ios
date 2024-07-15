//
//  TermsOfServiceViewController.swift
//  roome
//
//  Created by minsong kim on 5/19/24.
//

import UIKit
import Combine
import FirebaseAnalytics

class TermsAgreeViewController: UIViewController {
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    private lazy var errorPopUp = PopUpView(frame: window!.bounds, title: "에러 발생", description: "로그인 페이지로 돌아갑니다.", colorButtonTitle: "확인")
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
        configuration.imagePadding = 12
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 0)
        configuration.title = "모두 동의"
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .regularBody2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    private let ageAgreeButton: LabelButton = {
        let image = UIImage(systemName: "checkmark")?.changeImageColor( .lightGray).resize(newWidth: 12)
        
        let button = LabelButton(frame: .zero, isDetailButton: false)
        button.updateMainButton(title: "만 14세 이상입니다.(필수)", image: image)
        
        return button
    }()
    
    private let serviceAgreeButton: LabelButton = {
        let image = UIImage(systemName: "checkmark")?.changeImageColor( .lightGray).resize(newWidth: 12)
        
        let button = LabelButton(frame: .zero, isDetailButton: true)
        button.updateMainButton(title: "서비스 이용약관에 동의 (필수)", image: image)
        
        return button
    }()
    
    private let personalInformationAgreeButton: LabelButton = {
        let image = UIImage(systemName: "checkmark")?.changeImageColor( .lightGray).resize(newWidth: 12)
        
        let button = LabelButton(frame: .zero, isDetailButton: true)
        button.updateMainButton(title: "개인정보 수집 및 이용약관에 동의 (필수)", image: image)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.logEvent(Tracking.ServiceTerms.termsView, parameters: nil)
    }
    
    override func viewDidLayoutSubviews() {
        allAgreeButton.titleLabel?.font = .regularBody2
        ageAgreeButton.setNeedsLayout()
        serviceAgreeButton.setNeedsLayout()
        personalInformationAgreeButton.setNeedsLayout()
    }
    
    func bind() {
        allAgreeButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.viewModel.input.allAgree.send()
            }
            .store(in: &cancellable)
        
        ageAgreeButton.tappedMainButtonPublisher()
            .sink { [weak self] in
                self?.viewModel.input.ageAgree.send()
            }
            .store(in: &cancellable)
        
        serviceAgreeButton.tappedMainButtonPublisher()
            .sink { [weak self] in
                self?.viewModel.input.service.send(false)
            }
            .store(in: &cancellable)
        
        personalInformationAgreeButton.tappedMainButtonPublisher()
            .sink { [weak self] in
                self?.viewModel.input.personal.send(false)
            }
            .store(in: &cancellable)
        
        nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
            .map {
                Analytics.logEvent(Tracking.ServiceTerms.termsNextButton, parameters: nil)
            }
            .sink { [weak self] in
                self?.viewModel.input.next.send()
            }
            .store(in: &cancellable)

        backButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellable)
        
        viewModel.output.states
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
            }.store(in: &cancellable)
        
        viewModel.output.isNextButtonOn
            .sink { [weak self] isEnable in
                if isEnable {
                    self?.nextButton.isEnabled = true
                } else {
                    self?.nextButton.isEnabled = false
                }
            }.store(in: &cancellable)
        
        viewModel.output.isAllAgreeOn
            .sink { [weak self] isSelected in
                if isSelected {
                    self?.allAgreeButton.configuration?.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.roomeMain).resize(newWidth: 24)
                } else {
                    self?.allAgreeButton.configuration?.image = UIImage(systemName: "checkmark.circle.fill")?.changeImageColor(.lightGray).resize(newWidth: 24)
                }
            }.store(in: &cancellable)
        
        viewModel.output.goToNext
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { completion in
                switch completion {
                case .finished:
                    print("terms finished")
                case .failure(_):
                    self.window?.addSubview(self.errorPopUp)
                }
            } receiveValue: { [weak self] _ in
                let nextPage = DIContainer.shared.resolve(NicknameViewController.self)
                self?.navigationController?.pushViewController(nextPage, animated: true)
            }
            .store(in: &cancellable)
        
        errorPopUp.publisherColorButton()
            .sink { [weak self] _ in
                let next = DIContainer.shared.resolve(LoginViewController.self)
                self?.window?.rootViewController?.dismiss(animated: false)
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                    .changeRootViewController(next, animated: true)
            }
            .store(in: &cancellable)
        
        serviceAgreeButton.tappedDetailButtonPublisher()
            .sink { [weak self] _ in
                self?.viewModel.detailState = .service
                let detailView = DIContainer.shared.resolve(TermsDetailViewController.self)
                detailView.modalPresentationStyle = .fullScreen
                self?.view.window?.rootViewController?.present(detailView, animated: true)
            }.store(in: &cancellable)
        
        personalInformationAgreeButton.tappedDetailButtonPublisher()
            .sink { [weak self] _ in
                self?.viewModel.detailState = .personal
                let detailView = DIContainer.shared.resolve(TermsDetailViewController.self)
                detailView.modalPresentationStyle = .fullScreen
                self?.view.window?.rootViewController?.present(detailView, animated: true)
            }.store(in: &cancellable)
    }
    
    private func configureStackView() {
        view.addSubview(backButton)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(allAgreeButton)
        stackView.addArrangedSubview(ageAgreeButton)
        stackView.addArrangedSubview(serviceAgreeButton)
        stackView.addArrangedSubview(personalInformationAgreeButton)
        
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            
            allAgreeButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            allAgreeButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            ageAgreeButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            ageAgreeButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            serviceAgreeButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            serviceAgreeButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            personalInformationAgreeButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            personalInformationAgreeButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
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
