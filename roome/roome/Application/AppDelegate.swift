//
//  AppDelegate.swift
//  roome
//
//  Created by minsong kim on 4/17/24.
//

import UIKit
import KakaoSDKCommon
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var isLogin: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: Bundle.main.infoDictionary?["KakaoAppKey"] as! String)
        UITextField.appearance().tintColor = .roomeMain
        appleAutomaticLogin()
        return true
    }
    
    func appleAutomaticLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeyChain.read(key: .userID) ?? "") { credentialState, error in
            switch credentialState {
            case .authorized:
                self.isLogin = true
            default:
                self.isLogin = false
            }
        }
    }
}

