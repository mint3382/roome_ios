//
//  SplashView.swift
//  roome
//
//  Created by minsong kim on 5/20/24.
//

import UIKit

class SplashView: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setIsLogin()
    }
    
    private func setIsLogin() {
        if appDelegate?.isLogin  == true {
            goToMain()
        } else {
            goToLogin()
        }
    }
    
    func goToLogin() {
        let viewController = LoginViewController(
            viewModel: LoginViewModel(
                loginUseCase: LoginUseCase(loginRepository: LoginRepository(),
                                           userRepository: UserRepository())))
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(viewController, animated: true)
    }
    
    func goToMain() {
        let viewController = NicknameViewController(viewModel: NicknameViewModel(usecase: NicknameUseCase()))
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(viewController, animated: true)
    }
}
