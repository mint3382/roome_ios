//
//  SceneDelegate.swift
//  roome
//
//  Created by minsong kim on 4/17/24.
//

import UIKit
import KakaoSDKAuth
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    var isConnect: Bool = false  {
        didSet {
            print("isConnect = \(isConnect)")
            if !isConnect, let internetPopUp {
                window?.addSubview(internetPopUp)
            }
        }
    }
    
    private var internetPopUp: PopUpView?
    private var cancellable = Set<AnyCancellable>()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        DIManager.shared.registerAll()
        if connectionOptions.urlContexts.isEmpty {
            window?.rootViewController = SplashView()
        } else {
            self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        }
        window?.makeKeyAndVisible()
        
        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        InternetMonitor().startMonitoring()
        checkingInternetConnecting()
    }
    
    func changeRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard let window = self.window else {
            return
        }
        let navigateViewController = UINavigationController(rootViewController: viewController)
        navigateViewController.isNavigationBarHidden = true
        window.rootViewController = navigateViewController
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
        }
        
        let params = self.queryParams(url: url)
        let nickname = params["value"]
        if params["type"] == "profile" {
            let sharingContainer = SharingContainer(nickname: nickname ?? "닉네임")
            Task {
                do {
                    try await sharingContainer.updateSharingUserProfile(nickname: nickname ?? "닉네임")
                    if KeyChain.read(key: .hasToken) == "true" {
                        try await UserContainer.shared.updateUserProfile()
                    }
                    let sharedViewController = SharingViewController(sharingContainer: sharingContainer)
                    changeRootViewController(sharedViewController, animated: true)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func checkingInternetConnecting() {
        guard let window else {
            return
        }
        
        internetPopUp = PopUpView(frame: window.bounds,
                                  title: "인터넷에 연결할 수 없어요",
                                  description: "다시 시도해주세요.",
                                  colorButtonTitle: "다시 시도")
        
        bindInternetPopUp()
    }
    
    private func bindInternetPopUp() {
        internetPopUp?.publisherColorButton()
            .sink { [weak self] _ in
                self?.isConnect = true
                self?.internetPopUp?.removeFromSuperview()
            }
            .store(in: &cancellable)
    }

    private func queryParams(url: URL) -> Dictionary<String, String> {
        var parameters = Dictionary<String, String>()
    
        if let queryComponents = url.query?.components(separatedBy: "&") {
            for queryComponent in queryComponents {
                let paramComponents = queryComponent.components(separatedBy: "=")
                var object: String? = nil
                if paramComponents.count > 1 {
                    object = paramComponents[1].removingPercentEncoding
                }
                let key = paramComponents[0]
                parameters[key] = object
            }
        }
        return parameters
    }
}

