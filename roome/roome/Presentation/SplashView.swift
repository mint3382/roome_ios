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
        let nicknameRepository = NicknameRepository()
        
        DIContainer.shared.register(LoginRepository.self, dependency: loginRepository)
        DIContainer.shared.register(UserRepository.self, dependency: userRepository)
        DIContainer.shared.register(TermsAgreeRepository.self, dependency: termsAgreeRepository)
        DIContainer.shared.register(NicknameRepository.self, dependency: nicknameRepository)
        
        let loginUseCase = LoginUseCase(loginRepository: loginRepository, userRepository: userRepository)
        let termsAgreeUseCase = TermsAgreeUseCase(termsAgreeRepository: termsAgreeRepository)
        let nicknameUseCase = NicknameUseCase(nicknameRepository: nicknameRepository)

        DIContainer.shared.register(LoginUseCase.self, dependency: loginUseCase)
        DIContainer.shared.register(TermsAgreeUseCase.self, dependency: termsAgreeUseCase)
        DIContainer.shared.register(NicknameUseCase.self, dependency: nicknameUseCase)
        
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
        let termsAgreeViewModel = TermsAgreeViewModel(termsUseCase: termsAgreeUseCase)
        let nicknameViewModel = NicknameViewModel(usecase: nicknameUseCase)
        
        DIContainer.shared.register(LoginViewModel.self, dependency: loginViewModel)
        DIContainer.shared.register(TermsAgreeViewModel.self, dependency: termsAgreeViewModel)
        DIContainer.shared.register(NicknameViewModel.self, dependency: nicknameViewModel)
        
        
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        let termsAgreeViewController = TermsAgreeViewController(viewModel: termsAgreeViewModel)
        let nicknameViewController = NicknameViewController(viewModel: nicknameViewModel)
        let celebrateSignUpViewController = CelebrateSignUPViewController()
        
        DIContainer.shared.register(LoginViewController.self, dependency: loginViewController)
        DIContainer.shared.register(TermsAgreeViewController.self, dependency: termsAgreeViewController)
        DIContainer.shared.register(NicknameViewController.self, dependency: nicknameViewController)
        DIContainer.shared.register(CelebrateSignUPViewController.self, dependency: celebrateSignUpViewController)
        
    }
}
