//
//  SceneDelegate.swift
//  roome
//
//  Created by minsong kim on 4/17/24.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SplashView()
        window?.makeKeyAndVisible()
    }
    
    func changeRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard let window = self.window else {
            return
        }
        let navigateViewController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigateViewController
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}

