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
        if appDelegate?.isLogin == true {
            goToMain()
        } else {
            goToLogin()
        }
    }
    
    func goToLogin() {
        let viewController = DIContainer.shared.resolve(LoginViewController.self)
        let viewController2 = ProfileViewController()
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(viewController, animated: true)
    }
    
    func goToMain() {
        var viewController: UIViewController
        let userState = UserContainer.shared.user?.data.state
        
        switch UserState(rawValue: userState!) {
        case .termsAgreement:
            viewController = DIContainer.shared.resolve(TermsAgreeViewController.self)
        case .nickname:
            viewController = DIContainer.shared.resolve(NicknameViewController.self)
        case .registrationCompleted:
            viewController = DIContainer.shared.resolve(WelcomeSignUPViewController.self)
        case .none:
            viewController = DIContainer.shared.resolve(LoginViewController.self)
        }
        
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
        
        let genreRepository = GenreRepository()
        let genreUseCase = GenreUseCase(repository: genreRepository)
        let genreViewModel = GenreViewModel(useCase: genreUseCase)
        let genreViewController = GenreViewController(viewModel: genreViewModel)
        DIContainer.shared.register(GenreViewController.self, dependency: genreViewController)
        
        let mbtiRepository = MbtiRepository()
        let mbtiUseCase = MbtiUseCase(repository: mbtiRepository)
        let mbtiViewModel = MBTIViewModel(useCase: mbtiUseCase)
        let mbtiViewController = MBTIViewController(viewModel: mbtiViewModel)
        DIContainer.shared.register(MBTIViewController.self, dependency: mbtiViewController)
        
        let strengthRepository = StrengthRepository()
        let strengthUseCase = StrengthUseCase(repository: strengthRepository)
        let strengthViewModel = StrengthViewModel(useCase: strengthUseCase)
        let strengthViewController = StrengthViewController(viewModel: strengthViewModel)
        DIContainer.shared.register(StrengthViewController.self, dependency: strengthViewController)
        
        let themeRepository = ThemeSelectRepository()
        let themeUseCase = ThemeSelectUseCase(repository: themeRepository)
        let themeViewModel = ThemeSelectViewModel(useCase: themeUseCase)
        let themeSelectViewController = ThemeSelectViewController(viewModel: themeViewModel)
        DIContainer.shared.register(ThemeSelectViewController.self, dependency: themeSelectViewController)
        
        let horrorRepository = HorrorThemeRepository()
        let horrorUseCase = HorrorThemeUseCase(repository: horrorRepository)
        let horrorViewModel = HorrorPositionViewModel(useCase: horrorUseCase)
        let horrorPositionViewController = HorrorPositionViewController(viewModel: horrorViewModel)
        DIContainer.shared.register(HorrorPositionViewController.self, dependency: horrorPositionViewController)
        
        let hintRepository = HintRepository()
        let hintUseCase = HintUseCase(repository: hintRepository)
        let hintViewModel = HintViewModel(useCase: hintUseCase)
        let hintViewController = HintViewController(viewModel: hintViewModel)
        DIContainer.shared.register(HintViewController.self, dependency: hintViewController)
        
        let deviceLockRepository = DeviceLockRepository()
        let deviceLockUseCase = DeviceLockUseCase(repository: deviceLockRepository)
        let deviceLockViewModel = DeviceAndLockViewModel(useCase: deviceLockUseCase)
        let deviceAndLockViewController = DeviceAndLockViewController(viewModel: deviceLockViewModel)
        DIContainer.shared.register(DeviceAndLockViewController.self, dependency: deviceAndLockViewController)
        
        let activityRepository = ActivityRepository()
        let activityUseCase = ActivityUseCase(repository: activityRepository)
        let activityViewModel = ActivityViewModel(useCase: activityUseCase)
        let activityViewController = ActivityViewController(viewModel: activityViewModel)
        DIContainer.shared.register(ActivityViewController.self, dependency: activityViewController)
        
        let dislikeRepository = DislikeRepository()
        let dislikeUseCase = DislikeUseCase(repository: dislikeRepository)
        let dislikeViewModel = DislikeViewModel(useCase: dislikeUseCase)
        let dislikeViewController = DislikeViewController(viewModel: dislikeViewModel)
        DIContainer.shared.register(DislikeViewController.self, dependency: dislikeViewController)
        
        let colorRepository = ColorRepository()
        let colorUseCase = ColorUseCase(repository: colorRepository)
        let colorViewModel = ColorSelectViewModel(useCase: colorUseCase)
        let colorSelectViewController = ColorSelectViewController(viewModel: colorViewModel)
        DIContainer.shared.register(ColorSelectViewController.self, dependency: colorSelectViewController)
        
        let profileViewController = ProfileViewController()
        DIContainer.shared.register(ProfileViewController.self, dependency: profileViewController)
    }
}
