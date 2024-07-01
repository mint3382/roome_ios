//
//  SplashView.swift
//  roome
//
//  Created by minsong kim on 5/20/24.
//

import UIKit

class SplashView: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let logoView = UIImageView(image: UIImage(resource: .logo))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .roomeMain
        configureLogo()
    }
    
    func configureLogo() {
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
        if KeyChain.read(key: .hasToken) == "true" {
            Task { @MainActor in
                do {
                    try await UserContainer.shared.updateUserInformation()
                    try await UserContainer.shared.updateUserProfile()
                    setIsLogin()
                } catch {
                    goToLogin()
                }
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
