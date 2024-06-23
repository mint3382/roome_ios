//
//  DIManager.swift
//  roome
//
//  Created by minsong kim on 6/17/24.
//

import UIKit

class DIManager {
    static let shared = DIManager()
    
    private init() {}
    
    func registerAll() {
        registerLoginDependency()
        registerSignUPDependency()
        registerExtraDependency()
        registerProfileDependency()
        registerMainPageDependency()
    }
    
    private func registerLoginDependency() {
        let loginRepository = LoginRepository()
        let loginUseCase = LoginUseCase(loginRepository: loginRepository)
        let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        DIContainer.shared.register(LoginRepository.self, dependency: loginRepository)
        DIContainer.shared.register(LoginUseCase.self, dependency: loginUseCase)
        DIContainer.shared.register(LoginViewModel.self, dependency: loginViewModel)
        DIContainer.shared.register(LoginViewController.self, dependency: loginViewController)
    }
    
    private func registerSignUPDependency() {
        let termsAgreeRepository = TermsAgreeRepository()
        let termsAgreeUseCase = TermsAgreeUseCase(termsAgreeRepository: termsAgreeRepository)
        let termsAgreeViewModel = TermsAgreeViewModel(termsUseCase: termsAgreeUseCase)
        let termsAgreeViewController = TermsAgreeViewController(viewModel: termsAgreeViewModel)
        
        let termsDetailViewController = TermsDetailViewController(viewModel: termsAgreeViewModel)

        DIContainer.shared.register(TermsAgreeViewModel.self, dependency: termsAgreeViewModel)
        DIContainer.shared.register(TermsAgreeViewController.self, dependency: termsAgreeViewController)
        DIContainer.shared.register(TermsDetailViewController.self, dependency: termsDetailViewController)

        let nicknameRepository = NicknameRepository()
        let nicknameUseCase = NicknameUseCase(nicknameRepository: nicknameRepository)
        let nicknameViewModel = NicknameViewModel(usecase: nicknameUseCase)
        let nicknameViewController = NicknameViewController(viewModel: nicknameViewModel)
        
        DIContainer.shared.register(NicknameViewController.self, dependency: nicknameViewController)
    }
    
    private func registerProfileDependency() {
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
        let themeViewModel = ImportantFactorViewModel(useCase: themeUseCase)
        let themeSelectViewController = ImportantFactorViewController(viewModel: themeViewModel)
        DIContainer.shared.register(ImportantFactorViewController.self, dependency: themeSelectViewController)
        
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
        
        let profileCardViewModel = ProfileCardViewModel()
        let profileCardViewController = ProfileCardViewController(viewModel: profileCardViewModel)
        
        DIContainer.shared.register(ProfileCardViewController.self, dependency: profileCardViewController)
    }
    
    private func registerMainPageDependency() {
        let myProfileViewModel = MyProfileViewModel()
        let myProfileViewController = MyProfileViewController(viewModel: myProfileViewModel)
        DIContainer.shared.register(MyProfileViewController.self, dependency: myProfileViewController)
        
        let profileCardViewModel = ProfileCardViewModel()
        let myProfileCardViewController = MyProfileCardViewController(viewModel: profileCardViewModel)
        DIContainer.shared.register(MyProfileCardViewController.self, dependency: myProfileCardViewController)
        
        let settingViewModel = SettingViewModel(loginUseCase: DIContainer.shared.resolve(LoginUseCase.self))
        let settingViewController = SettingViewController(viewModel: settingViewModel)
        let settingWebViewController = SettingWebViewController(viewModel: settingViewModel)
        DIContainer.shared.register(SettingViewController.self, dependency: settingViewController)
        DIContainer.shared.register(SettingWebViewController.self, dependency: settingWebViewController)
        
        
        let tabBarController = TabBarController()
        DIContainer.shared.register(TabBarController.self, dependency: tabBarController)
    }
    
    private func registerExtraDependency() {
        guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return
        }
        
        let loadingView = LoadingView(frame: window.frame)
        DIContainer.shared.register(LoadingView.self, dependency: loadingView)
    }
}
