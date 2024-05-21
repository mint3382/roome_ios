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
        registerLoginDependency()
        setIsLogin()
    }
    
    private func setIsLogin() {
        if appDelegate?.isLogin  == true {
            goToMain()
            registerProfileDependency()
        } else {
            goToLogin()
            registerSignUPDependency()
            registerProfileDependency()
        }
    }
    
    func goToLogin() {
        let viewController = DIContainer.shared.resolve(LoginViewController.self)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(viewController, animated: true)
    }
    
    func goToMain() {
        let viewController = DIContainer.shared.resolve(WelcomeSignUPViewController.self)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(viewController, animated: true)
    }
    
    func registerLoginDependency() {
        let loginRepository = LoginRepository()
        let userRepository = UserRepository()
        
        DIContainer.shared.register(LoginRepository.self, dependency: loginRepository)
        DIContainer.shared.register(UserRepository.self, dependency: userRepository)
        
        let loginUseCase = LoginUseCase(loginRepository: loginRepository, userRepository: userRepository)

        DIContainer.shared.register(LoginUseCase.self, dependency: loginUseCase)
        
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
        
        DIContainer.shared.register(LoginViewModel.self, dependency: loginViewModel)
        
        let loginViewController = LoginViewController(viewModel: loginViewModel)

        DIContainer.shared.register(LoginViewController.self, dependency: loginViewController)
    }
    
    func registerSignUPDependency() {
        let termsAgreeRepository = TermsAgreeRepository()
        let nicknameRepository = NicknameRepository()
        DIContainer.shared.register(TermsAgreeRepository.self, dependency: termsAgreeRepository)
        DIContainer.shared.register(NicknameRepository.self, dependency: nicknameRepository)
        
        let termsAgreeUseCase = TermsAgreeUseCase(termsAgreeRepository: termsAgreeRepository)
        let nicknameUseCase = NicknameUseCase(nicknameRepository: nicknameRepository)
        DIContainer.shared.register(TermsAgreeUseCase.self, dependency: termsAgreeUseCase)
        DIContainer.shared.register(NicknameUseCase.self, dependency: nicknameUseCase)
        
        let termsAgreeViewModel = TermsAgreeViewModel(termsUseCase: termsAgreeUseCase)
        let nicknameViewModel = NicknameViewModel(usecase: nicknameUseCase)
        DIContainer.shared.register(TermsAgreeViewModel.self, dependency: termsAgreeViewModel)
        DIContainer.shared.register(NicknameViewModel.self, dependency: nicknameViewModel)
        
        let termsAgreeViewController = TermsAgreeViewController(viewModel: termsAgreeViewModel)
        let nicknameViewController = NicknameViewController(viewModel: nicknameViewModel)
        DIContainer.shared.register(TermsAgreeViewController.self, dependency: termsAgreeViewController)
        DIContainer.shared.register(NicknameViewController.self, dependency: nicknameViewController)
    }
    
    func registerProfileDependency() {
        let welcomeViewModel = WelcomeViewModel()
        DIContainer.shared.register(WelcomeViewModel.self, dependency: welcomeViewModel)
        
        let welcomeSignUPViewController = WelcomeSignUPViewController(viewModel: welcomeViewModel)
        DIContainer.shared.register(WelcomeSignUPViewController.self, dependency: welcomeSignUPViewController)
    }
}
