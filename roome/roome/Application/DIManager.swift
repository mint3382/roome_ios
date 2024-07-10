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
        
        DIContainer.shared.register(NicknameUseCase.self, dependency: nicknameUseCase)
        DIContainer.shared.register(NicknameViewController.self, dependency: nicknameViewController)
    }
    
    private func registerProfileDependency() {
        let welcomeViewModel = WelcomeViewModel()
        let welcomeSignUPViewController = WelcomeSignUPViewController(viewModel: welcomeViewModel)
        DIContainer.shared.register(WelcomeViewModel.self, dependency: welcomeViewModel)
        DIContainer.shared.register(WelcomeSignUPViewController.self, dependency: welcomeSignUPViewController)
        
        let profileSelectRepository = ProfileSelectRepository()
        let profileSelectUseCase = ProfileSelectUseCase(repository: profileSelectRepository)
        
        let roomCountViewModel = RoomCountViewModel(usecase: profileSelectUseCase)
        let roomCountViewController = RoomCountViewController(viewModel: roomCountViewModel)
        DIContainer.shared.register(RoomCountViewController.self, dependency: roomCountViewController)
        
        let genreViewModel = GenreViewModel(useCase: profileSelectUseCase)
        let genreViewController = GenreViewController(viewModel: genreViewModel)
        DIContainer.shared.register(GenreViewController.self, dependency: genreViewController)
        
        let mbtiViewModel = MBTIViewModel(useCase: profileSelectUseCase)
        let mbtiViewController = MBTIViewController(viewModel: mbtiViewModel)
        DIContainer.shared.register(MBTIViewController.self, dependency: mbtiViewController)
        
        let strengthViewModel = StrengthViewModel(useCase: profileSelectUseCase)
        let strengthViewController = StrengthViewController(viewModel: strengthViewModel)
        DIContainer.shared.register(StrengthViewController.self, dependency: strengthViewController)
        
        let themeViewModel = ImportantFactorViewModel(useCase: profileSelectUseCase)
        let themeSelectViewController = ImportantFactorViewController(viewModel: themeViewModel)
        DIContainer.shared.register(ImportantFactorViewController.self, dependency: themeSelectViewController)
        
        let horrorViewModel = HorrorPositionViewModel(useCase: profileSelectUseCase)
        let horrorPositionViewController = HorrorPositionViewController(viewModel: horrorViewModel)
        DIContainer.shared.register(HorrorPositionViewController.self, dependency: horrorPositionViewController)
        
        let hintViewModel = HintViewModel(useCase: profileSelectUseCase)
        let hintViewController = HintViewController(viewModel: hintViewModel)
        DIContainer.shared.register(HintViewController.self, dependency: hintViewController)
        
        let deviceLockViewModel = DeviceAndLockViewModel(useCase: profileSelectUseCase)
        let deviceAndLockViewController = DeviceAndLockViewController(viewModel: deviceLockViewModel)
        DIContainer.shared.register(DeviceAndLockViewController.self, dependency: deviceAndLockViewController)
        
        let activityViewModel = ActivityViewModel(useCase: profileSelectUseCase)
        let activityViewController = ActivityViewController(viewModel: activityViewModel)
        DIContainer.shared.register(ActivityViewController.self, dependency: activityViewController)
        
        let dislikeViewModel = DislikeViewModel(useCase: profileSelectUseCase)
        let dislikeViewController = DislikeViewController(viewModel: dislikeViewModel)
        DIContainer.shared.register(DislikeViewController.self, dependency: dislikeViewController)
        
        let colorViewModel = ColorSelectViewModel(useCase: profileSelectUseCase)
        let colorSelectViewController = ColorSelectViewController(viewModel: colorViewModel)
        DIContainer.shared.register(ColorSelectViewController.self, dependency: colorSelectViewController)
        
        let profileCardViewModel = ProfileCardViewModel()
        let profileCardViewController = ProfileCardViewController(viewModel: profileCardViewModel)
        DIContainer.shared.register(ProfileCardViewController.self, dependency: profileCardViewController)
        
        let editRoomContViewController = EditRoomCountViewController(viewModel: roomCountViewModel)
        DIContainer.shared.register(EditRoomCountViewController.self, dependency: editRoomContViewController)
        
        let editGenreViewController = EditGenreViewController(viewModel: genreViewModel)
        DIContainer.shared.register(EditGenreViewController.self, dependency: editGenreViewController)
        
        let editMBTIViewController = EditMBTIViewController(viewModel: mbtiViewModel)
        DIContainer.shared.register(EditMBTIViewController.self, dependency: editMBTIViewController)
        
        let editStrengthViewController = EditStrengthViewController(viewModel: strengthViewModel)
        DIContainer.shared.register(EditStrengthViewController.self, dependency: editStrengthViewController)
        
        let editImportantFactorViewController = EditImportantFactorViewController(viewModel: themeViewModel)
        DIContainer.shared.register(EditImportantFactorViewController.self, dependency: editImportantFactorViewController)
        
        let editHorrorPositionViewController = EditHorrorPositionViewController(viewModel: horrorViewModel)
        DIContainer.shared.register(EditHorrorPositionViewController.self, dependency: editHorrorPositionViewController)
        
        let editHintViewController = EditHintViewController(viewModel: hintViewModel)
        DIContainer.shared.register(EditHintViewController.self, dependency: editHintViewController)
        
        let editDeviceAndLockViewController = EditDeviceAndLockViewController(viewModel: deviceLockViewModel)
        DIContainer.shared.register(EditDeviceAndLockViewController.self, dependency: editDeviceAndLockViewController)
        
        let editActivityViewController = EditActivityViewController(viewModel: activityViewModel)
        DIContainer.shared.register(EditActivityViewController.self, dependency: editActivityViewController)
        
        let editDislikeViewController = EditDislikeViewController(viewModel: dislikeViewModel)
        DIContainer.shared.register(EditDislikeViewController.self, dependency: editDislikeViewController)
        
        let editColorViewController = EditColorViewController(viewModel: colorViewModel)
        DIContainer.shared.register(EditColorViewController.self, dependency: editColorViewController)
    }
    
    private func registerMainPageDependency() {
        let myProfileViewModel = MyProfileViewModel()
        let myProfileViewController = MyProfileViewController(viewModel: myProfileViewModel)
        DIContainer.shared.register(MyProfileViewController.self, dependency: myProfileViewController)
        
        let profileCardViewModel = ProfileCardViewModel()
        let myProfileCardViewController = MyProfileCardViewController(viewModel: profileCardViewModel)
        DIContainer.shared.register(MyProfileCardViewController.self, dependency: myProfileCardViewController)
        
        let userProfileRepository = UserProfileRepository()
        let userProfileUseCase = UserProfileUseCase(userProfileRepository: userProfileRepository)
        let editProfileViewModel = EditProfileViewModel(usecase: userProfileUseCase)
        let editProfileViewController = EditProfileViewController(viewModel: editProfileViewModel)
        DIContainer.shared.register(UserProfileUseCase.self, dependency: userProfileUseCase)
        DIContainer.shared.register(EditProfileViewController.self, dependency: editProfileViewController)
        
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
