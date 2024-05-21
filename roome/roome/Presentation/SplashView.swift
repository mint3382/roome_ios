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
        registerDependency()
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
        let viewController = DIContainer.shared.resolve(LoginViewController.self)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(viewController, animated: true)
    }
    
    func goToMain() {
        let viewController = DIContainer.shared.resolve(NicknameViewController.self)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(viewController, animated: true)
    }
    
    func registerDependency() {
        let loginRepository = LoginRepository()
        let userRepository = UserRepository()
        let termsAgreeRepository = TermsAgreeRepository()
        
        DIContainer.shared.register(LoginRepository.self, dependency: loginRepository)
        DIContainer.shared.register(UserRepository.self, dependency: userRepository)
        DIContainer.shared.register(TermsAgreeRepository.self, dependency: termsAgreeRepository)
        
        let loginUseCase = LoginUseCase(loginRepository: loginRepository, userRepository: userRepository)
        let nicknameUseCase = NicknameUseCase()
        let termsAgreeUseCase = TermsAgreeUseCase(termsAgreeRepository: termsAgreeRepository)

        DIContainer.shared.register(LoginUseCase.self, dependency: loginUseCase)
        DIContainer.shared.register(NicknameUseCase.self, dependency: nicknameUseCase)
        DIContainer.shared.register(TermsAgreeUseCase.self, dependency: termsAgreeUseCase)
        
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
        let nicknameViewModel = NicknameViewModel(usecase: nicknameUseCase)
        let termsAgreeViewModel = TermsAgreeViewModel(termsUseCase: termsAgreeUseCase)
        
        DIContainer.shared.register(LoginViewModel.self, dependency: loginViewModel)
        DIContainer.shared.register(NicknameViewModel.self, dependency: nicknameViewModel)
        DIContainer.shared.register(TermsAgreeViewModel.self, dependency: termsAgreeViewModel)
        
        
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        let nicknameViewController = NicknameViewController(viewModel: nicknameViewModel)
        let termsAgreeViewController = TermsAgreeViewController(viewModel: termsAgreeViewModel)
        
        DIContainer.shared.register(LoginViewController.self, dependency: loginViewController)
        DIContainer.shared.register(NicknameViewController.self, dependency: nicknameViewController)
        DIContainer.shared.register(TermsAgreeViewController.self, dependency: termsAgreeViewController)
        
    }
}
