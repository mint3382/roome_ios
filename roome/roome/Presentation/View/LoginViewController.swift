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
        button.addTarget(self, action: #selector(pushedKakaoLoginButton), for: .touchUpInside)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = UIImage(resource: .kakaoLoginButton).resize(newWidth: view.frame.width * 0.9)
        
        button.configuration = buttonConfiguration
        
        return button
    }()
    
    lazy var appleLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(pushedAppleLoginButton), for: .touchUpInside)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = UIImage(resource: .appleLoginButton).resize(newWidth: view.frame.width * 0.9)
        
        button.configuration = buttonConfiguration
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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

    @objc
    private func pushedKakaoLoginButton() {
        viewModel.pushedKakaoLoginButton()
    }
    
    @objc
    private func pushedAppleLoginButton() {
        viewModel.pushedAppleLoginButton()
    }
    
    private func bind() {
        viewModel.loginPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let failure):
                    print("\(failure)")
                }
            }, receiveValue: { _ in
                print("로그인 성공")
            }).store(in: &cancellables)
    }
}
