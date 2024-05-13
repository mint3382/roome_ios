//
//  ViewController.swift
//  roome
//
//  Created by minsong kim on 4/17/24.
//

import UIKit

class LoginViewController: UIViewController {
    //로그인 버튼
    lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(pushedKakaoLoginButton), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = UIImage(resource: .kakaoLoginButton).resize(newWidth: view.frame.width * 0.9)
        buttonConfiguration.contentInsets = .init(top: 25, leading: 0, bottom: 0, trailing: 0)
        
        button.configuration = buttonConfiguration
        
        return button
    }()
    
    lazy var appleLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(pushedAppleLoginButton), for: .touchUpInside)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = UIImage(resource: .appleLoginButton).resize(newWidth: view.frame.width * 0.9)
        buttonConfiguration.contentInsets = .init(top: -20, leading: 0, bottom: 0, trailing: 0)
        
        button.configuration = buttonConfiguration
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @objc
    private func pushedKakaoLoginButton() {
        
    }
    
    @objc
    private func pushedAppleLoginButton() {
        
    }
}

