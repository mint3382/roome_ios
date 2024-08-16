//
//  AppDelegate.swift
//  roome
//
//  Created by minsong kim on 4/17/24.
//

import AuthenticationServices
import AppTrackingTransparency
import Firebase
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var isLogin: Bool = false 
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: Bundle.main.infoDictionary?["KakaoAppKey"] as! String)
        UITextField.appearance().tintColor = .roomeMain
        UITextView.appearance().tintColor = .roomeMain
        if KeyChain.read(key: .isAppleLogin) == "true" {
            appleAutomaticLogin()
        } else {
            kakaoAutomaticLogin()
        }
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    private func appleAutomaticLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeyChain.read(key: .appleUserID) ?? "") { credentialState, error in
            switch credentialState {
            case .authorized:
                self.isLogin = true
            default:
                self.isLogin = false
            }
        }
    }
    
    private func kakaoAutomaticLogin() {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        self.isLogin = false
                    }
                } else {
                    //success
                    self.isLogin = true
                }
            }
        }
        else {
            self.isLogin = false
        }
    }
}
