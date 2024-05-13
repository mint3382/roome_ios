//
//  ViewController.swift
//  roome
//
//  Created by minsong kim on 4/17/24.
//

import UIKit

class LoginViewController: UIViewController {
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
        
    }
    
    @objc
    private func pushedAppleLoginButton() {
        
    }
}
