//
//  ViewController.swift
//  roome
//
//  Created by minsong kim on 4/17/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private var viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.spacing = 4
        
        return stack
    }()
    //로그인 버튼
    lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = UIImage(resource: .kakaoLoginButton).resize(newWidth: view.frame.width * 0.9)
        
        button.configuration = buttonConfiguration
        
        return button
    }()
    
    lazy var appleLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = UIImage(resource: .appleLoginButton).resize(newWidth: view.frame.width * 0.9)
        
        button.configuration = buttonConfiguration
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(kakaoLoginButton)
        stackView.addArrangedSubview(appleLoginButton)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func bind() {
        let apple = appleLoginButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        let kakao = kakaoLoginButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        
        let output = viewModel.transform(LoginViewModel.LoginInput(apple: apple, kakao: kakao))
        
        output.state
            .throttle(for: 1, scheduler: RunLoop.main, latest: false)
            .sink { error in
                print(error)
            } receiveValue: { state in
                self.goToNextPage(state)
            }.store(in: &cancellables)

    }
    
    private func goToNextPage(_ state: UserState) {
            var nextPage = UIViewController()
            switch state {
            case .registrationCompleted:
                print("registrationCompleted")
                nextPage = DIContainer.shared.resolve(WelcomeSignUPViewController.self)
            case .termsAgreement:
                nextPage = DIContainer.shared.resolve(TermsAgreeViewController.self)
                print("termsAgreement")
            case .nickname:
                nextPage = DIContainer.shared.resolve(NicknameViewController.self)
                print("nickname")
            }
            navigationController?.pushViewController(nextPage, animated: true)
    }
}
