//
//  SplashView.swift
//  roome
//
//  Created by minsong kim on 5/20/24.
//

import UIKit

class SplashView: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if KeyChain.read(key: .hasToken) == "true" {
            Task { @MainActor in
                registerLoginDependency()
                registerSignUPDependency()
                registerProfileDependency()
                do {
                    try await UserContainer.shared.updateUserInformation()
                    setIsLogin()
                } catch {
                    goToLogin()
                }
            }
        } else {
            registerLoginDependency()
            registerSignUPDependency()
            registerProfileDependency()
            setIsLogin()
        }
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
        let viewController = DIContainer.shared.resolve(WelcomeSignUPViewController.self)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(viewController, animated: true)
    }
    
    func registerLoginDependency() {
        let loginRepository = LoginRepository()
        let loginUseCase = LoginUseCase(loginRepository: loginRepository)
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        DIContainer.shared.register(LoginRepository.self, dependency: loginRepository)
        DIContainer.shared.register(LoginUseCase.self, dependency: loginUseCase)
        DIContainer.shared.register(LoginViewModel.self, dependency: loginViewModel)
        DIContainer.shared.register(LoginViewController.self, dependency: loginViewController)
    }
    
    func registerSignUPDependency() {
        let termsAgreeRepository = TermsAgreeRepository()
        let termsAgreeUseCase = TermsAgreeUseCase(termsAgreeRepository: termsAgreeRepository)
        let termsAgreeViewModel = TermsAgreeViewModel(termsUseCase: termsAgreeUseCase)
        let termsAgreeViewController = TermsAgreeViewController(viewModel: termsAgreeViewModel)
        DIContainer.shared.register(TermsAgreeRepository.self, dependency: termsAgreeRepository)
        DIContainer.shared.register(TermsAgreeUseCase.self, dependency: termsAgreeUseCase)
        DIContainer.shared.register(TermsAgreeViewModel.self, dependency: termsAgreeViewModel)
        DIContainer.shared.register(TermsAgreeViewController.self, dependency: termsAgreeViewController)

        let nicknameRepository = NicknameRepository()
        let nicknameUseCase = NicknameUseCase(nicknameRepository: nicknameRepository)
        let nicknameViewModel = NicknameViewModel(usecase: nicknameUseCase)
        let nicknameViewController = NicknameViewController(viewModel: nicknameViewModel)
        DIContainer.shared.register(NicknameRepository.self, dependency: nicknameRepository)
        DIContainer.shared.register(NicknameUseCase.self, dependency: nicknameUseCase)
        DIContainer.shared.register(NicknameViewModel.self, dependency: nicknameViewModel)
        DIContainer.shared.register(NicknameViewController.self, dependency: nicknameViewController)
    }
    
    func registerProfileDependency() {
        let welcomeViewModel = WelcomeViewModel()
        let welcomeSignUPViewController = WelcomeSignUPViewController(viewModel: welcomeViewModel)
        DIContainer.shared.register(WelcomeViewModel.self, dependency: welcomeViewModel)
        DIContainer.shared.register(WelcomeSignUPViewController.self, dependency: welcomeSignUPViewController)
        
        let roomCountRepository = RoomCountRepository()
        let roomCountUseCase = RoomCountUseCase(repository: roomCountRepository)
        let roomCountViewModel = RoomCountViewModel(usecase: roomCountUseCase)
        let roomCountViewController = RoomCountViewController(viewModel: roomCountViewModel)
        DIContainer.shared.register(RoomCountRepository.self, dependency: roomCountRepository)
        DIContainer.shared.register(RoomCountUseCase.self, dependency: roomCountUseCase)
        DIContainer.shared.register(RoomCountViewModel.self, dependency: roomCountViewModel)
        DIContainer.shared.register(RoomCountViewController.self, dependency: roomCountViewController)
        
        let genreViewController = GenreViewController(viewModel: GenreViewModel())
        DIContainer.shared.register(GenreViewController.self, dependency: genreViewController)
        
        let mbtiViewController = MBTIViewController(viewModel: MBTIViewModel())
        DIContainer.shared.register(MBTIViewController.self, dependency: mbtiViewController)
        
        let strengthViewController = StrengthViewController()
        DIContainer.shared.register(StrengthViewController.self, dependency: strengthViewController)
        
    }
}
