//
//  SplashView.swift
//  roome
//
//  Created by minsong kim on 5/20/24.
//

import Combine
import UIKit

class SplashView: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let logoView = UIImageView(image: UIImage(resource: .logo))
    private let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first
    private lazy var updatePopUp = PopUpView(frame: window!.bounds, title: "앱 업데이트가 필요해요", description: "안정적인 서비스 사용을 위해\n최신 버전으로 업데이트해 주세요.", colorButtonTitle: "업데이트")
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .roomeMain
        configureLogo()
        bind()
    }
    
    private func bind() {
        updatePopUp.publisherColorButton()
            .sink { [weak self] in
                if let url = URL(string: "itms-apps://itunes.apple.com/app/6503616766"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                self?.updatePopUp.removeFromSuperview()
            }
            .store(in: &cancellables)
    }
    
    private func configureLogo() {
        view.addSubview(logoView)
        logoView.contentMode = .scaleAspectFit
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 200),
            logoView.heightAnchor.constraint(equalToConstant: 37)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task { @MainActor in
            let leastVersion = await VersionManager.requestLeastVersion()?.components(separatedBy: ".")
            let currentVersion = VersionManager.currentVersion?.components(separatedBy: ".")
            
            guard let leastVersion, let currentVersion else {
                return
            }
            
            if (leastVersion[0] > currentVersion[0]) || 
                (leastVersion[1] > currentVersion[1]) {
                window?.addSubview(updatePopUp)
            } else {
                await checkLoginToken()
            }
        }
    }
    
    private func checkLoginToken() async {
        if KeyChain.read(key: .hasToken) == "true" {
                do {
                    try await UserContainer.shared.updateUserInformation()
                    try await UserContainer.shared.updateUserProfile()
                    try await UserContainer.shared.updateDefaultProfile()
                    setIsLogin()
                } catch {
                    goToLogin()
                }
        } else {
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
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(viewController, animated: true)
    }
    
    func goToMain() {
        var viewController: UIViewController
        guard let userState = UserContainer.shared.user?.data.state else {
            //UserState가 없을 때?
            viewController = DIContainer.shared.resolve(LoginViewController.self)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                .changeRootViewController(viewController, animated: true)
            return
        }
        
        switch UserState(rawValue: userState) {
        case .termsAgreement:
            viewController = DIContainer.shared.resolve(TermsAgreeViewController.self)
        case .nickname:
            viewController = DIContainer.shared.resolve(NicknameViewController.self)
        case .registrationCompleted:
            if UserContainer.shared.profile?.data.state == StateDTO.complete.rawValue {
                viewController = DIContainer.shared.resolve(TabBarController.self)
            } else {
                viewController = DIContainer.shared.resolve(WelcomeSignUPViewController.self)
            }
        case .none:
            viewController = DIContainer.shared.resolve(LoginViewController.self)
        }
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
            .changeRootViewController(viewController, animated: true)
    }
}
